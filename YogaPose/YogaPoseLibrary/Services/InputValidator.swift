//
//  InputValidator.swift
//  YogaPoseLibrary
//
//  Reusable input rules. Every function returns an error message,
//  or `nil` when the input is valid.
//

import Foundation

enum InputValidator {

    static let minPasswordLength = 8

    static func fullNameIssue(_ value: String) -> String? {
        let name = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty { return "Full name is required." }
        if name.count < 2 { return "Full name must be at least 2 characters." }
        return nil
    }

    static func usernameIssue(_ value: String) -> String? {
        let name = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty { return "Username is required." }
        let pattern = "^[A-Za-z0-9_]{3,20}$"
        if name.range(of: pattern, options: .regularExpression) == nil {
            return "Username must be 3–20 characters: letters, numbers or underscore."
        }
        return nil
    }

    static func emailIssue(_ value: String) -> String? {
        let email = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if email.isEmpty { return "Email address is required." }
        let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        if email.range(of: pattern, options: .regularExpression) == nil {
            return "Enter a valid email address."
        }
        return nil
    }

    static func passwordIssue(_ value: String) -> String? {
        if value.isEmpty { return "Password is required." }
        if value.count < minPasswordLength {
            return "Password must be at least \(minPasswordLength) characters."
        }
        let hasLetter = value.rangeOfCharacter(from: .letters) != nil
        let hasDigit = value.rangeOfCharacter(from: .decimalDigits) != nil
        if !hasLetter || !hasDigit {
            return "Password must include at least one letter and one number."
        }
        return nil
    }

    static func confirmPasswordIssue(password: String, confirmation: String) -> String? {
        if confirmation.isEmpty { return "Please confirm your password." }
        if confirmation != password { return "Passwords do not match." }
        return nil
    }
}
