//
//  ForgotPasswordViewModel.swift
//  YogaPoseLibrary
//
//  Logic for resetting a password. The account is verified by
//  matching BOTH the username and the email address.
//

import Foundation

enum ForgotPasswordField: Hashable {
    case username
    case email
    case newPassword
    case confirmPassword
}

@MainActor
final class ForgotPasswordViewModel: ObservableObject {

    @Published var username = ""
    @Published var email = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""

    @Published private(set) var errors: [ForgotPasswordField: String] = [:]
    @Published private(set) var generalError: String?
    @Published var showSuccess = false

    private let store: AccountStoring

    init(store: AccountStoring = AccountStore()) {
        self.store = store
    }

    func error(for field: ForgotPasswordField) -> String? {
        errors[field]
    }

    func submit() {
        generalError = nil
        guard validate() else { return }

        do {
            try store.resetPassword(
                username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                newPassword: newPassword
            )
            showSuccess = true
        } catch AccountError.accountNotFound {
            generalError = "No account matches that username and email address."
        } catch {
            generalError = "Couldn't update your password. Please try again."
        }
    }

    private func validate() -> Bool {
        var found: [ForgotPasswordField: String] = [:]
        found[.username] = InputValidator.usernameIssue(username)
        found[.email] = InputValidator.emailIssue(email)
        found[.newPassword] = InputValidator.passwordIssue(newPassword)
        found[.confirmPassword] = InputValidator.confirmPasswordIssue(password: newPassword, confirmation: confirmPassword)
        errors = found
        return found.isEmpty
    }
}
