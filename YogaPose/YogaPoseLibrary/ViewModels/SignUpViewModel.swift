//
//  SignUpViewModel.swift
//  YogaPoseLibrary
//
//  Validation and registration logic for the Sign Up screen.
//

import Foundation

enum SignUpField: Hashable {
    case fullName
    case username
    case email
    case password
    case confirmPassword
}

@MainActor
final class SignUpViewModel: ObservableObject {

    @Published var fullName = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published private(set) var errors: [SignUpField: String] = [:]
    @Published private(set) var generalError: String?
    @Published var showSuccess = false

    private let store: AccountStoring

    init(store: AccountStoring = AccountStore()) {
        self.store = store
    }

    func error(for field: SignUpField) -> String? {
        errors[field]
    }

    /// Validates the form and, if valid, saves the new account.
    func submit() {
        generalError = nil
        guard validate() else { return }

        do {
            _ = try store.register(
                fullName: fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            showSuccess = true
        } catch AccountError.usernameTaken {
            errors[.username] = "This username is already taken."
        } catch AccountError.emailTaken {
            errors[.email] = "An account with this email already exists."
        } catch {
            generalError = "Couldn't save your account. Please try again."
        }
    }

    private func validate() -> Bool {
        var found: [SignUpField: String] = [:]
        found[.fullName] = InputValidator.fullNameIssue(fullName)
        found[.username] = InputValidator.usernameIssue(username)
        found[.email] = InputValidator.emailIssue(email)
        found[.password] = InputValidator.passwordIssue(password)
        found[.confirmPassword] = InputValidator.confirmPasswordIssue(password: password, confirmation: confirmPassword)
        errors = found
        return found.isEmpty
    }
}
