//
//  AccountStore.swift
//  YogaPoseLibrary
//
//  Saves registered users securely in the Keychain and verifies logins.
//

import Foundation

enum AccountError: Error {
    case usernameTaken
    case emailTaken
    case accountNotFound
    case storageFailure
}

protocol AccountStoring {
    /// Creates and saves a new account. Throws `AccountError` on duplicates or storage problems.
    func register(fullName: String, username: String, email: String, password: String) throws -> UserAccount

    /// Returns the account if the username-or-email and password are correct, otherwise `nil`.
    func authenticate(identifier: String, password: String) -> UserAccount?

    /// Sets a new password for the account whose username AND email both match.
    func resetPassword(username: String, email: String, newPassword: String) throws

    /// Finds an account by its unique id.
    func account(withID id: UUID) -> UserAccount?
}

final class AccountStore: AccountStoring {

    private let keychain: KeychainService
    private let storageKey = "registered_users"

    init(keychain: KeychainService = KeychainService()) {
        self.keychain = keychain
    }

    // MARK: - Registration

    func register(fullName: String, username: String, email: String, password: String) throws -> UserAccount {
        var accounts = loadAccounts()

        if accounts.contains(where: { $0.username.caseInsensitiveCompare(username) == .orderedSame }) {
            throw AccountError.usernameTaken
        }
        if accounts.contains(where: { $0.email.caseInsensitiveCompare(email) == .orderedSame }) {
            throw AccountError.emailTaken
        }

        let salt = PasswordHasher.makeSalt()
        let account = UserAccount(
            id: UUID(),
            fullName: fullName,
            username: username,
            email: email.lowercased(),
            passwordHash: PasswordHasher.hash(password: password, salt: salt),
            salt: salt,
            createdAt: Date()
        )
        accounts.append(account)
        try saveAccounts(accounts)
        return account
    }

    // MARK: - Login

    func authenticate(identifier: String, password: String) -> UserAccount? {
        let accounts = loadAccounts()
        guard let account = accounts.first(where: {
            $0.username.caseInsensitiveCompare(identifier) == .orderedSame
                || $0.email.caseInsensitiveCompare(identifier) == .orderedSame
        }) else {
            return nil
        }

        let hash = PasswordHasher.hash(password: password, salt: account.salt)
        return hash == account.passwordHash ? account : nil
    }

    // MARK: - Lookup

    func account(withID id: UUID) -> UserAccount? {
        loadAccounts().first { $0.id == id }
    }

    // MARK: - Password reset

    func resetPassword(username: String, email: String, newPassword: String) throws {
        var accounts = loadAccounts()
        guard let index = accounts.firstIndex(where: {
            $0.username.caseInsensitiveCompare(username) == .orderedSame
                && $0.email.caseInsensitiveCompare(email) == .orderedSame
        }) else {
            throw AccountError.accountNotFound
        }

        let salt = PasswordHasher.makeSalt()
        accounts[index].salt = salt
        accounts[index].passwordHash = PasswordHasher.hash(password: newPassword, salt: salt)
        try saveAccounts(accounts)
    }

    // MARK: - Keychain persistence

    private func loadAccounts() -> [UserAccount] {
        do {
            guard let data = try keychain.load(for: storageKey) else { return [] }
            return try JSONDecoder().decode([UserAccount].self, from: data)
        } catch {
            return []
        }
    }

    private func saveAccounts(_ accounts: [UserAccount]) throws {
        do {
            let data = try JSONEncoder().encode(accounts)
            try keychain.save(data, for: storageKey)
        } catch {
            throw AccountError.storageFailure
        }
    }
}
