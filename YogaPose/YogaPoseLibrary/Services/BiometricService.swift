//
//  BiometricService.swift
//  YogaPoseLibrary
//
//  Wraps LocalAuthentication (Face ID / Touch ID).
//

import Foundation
import LocalAuthentication

enum BiometricResult {
    case success
    /// The user dismissed the prompt.
    case cancelled
    /// The user tapped the "Use Password" button in the system prompt.
    case fallbackRequested
    case failed(String)
}

protocol BiometricAuthenticating {
    var isAvailable: Bool { get }
    var biometryName: String { get }
    var biometryIconName: String { get }
    func authenticate(reason: String) async -> BiometricResult
}

struct BiometricService: BiometricAuthenticating {

    var isAvailable: Bool {
        var error: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    var biometryName: String {
        let context = LAContext()
        var error: NSError?
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        switch context.biometryType {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        default: return "Biometrics"
        }
    }

    var biometryIconName: String {
        biometryName == "Touch ID" ? "touchid" : "faceid"
    }

    func authenticate(reason: String) async -> BiometricResult {
        let context = LAContext()
        context.localizedFallbackTitle = "Use Password"
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return success ? .success : .failed("Authentication failed. Please try again.")
        } catch let error as LAError {
            switch error.code {
            case .userCancel, .systemCancel, .appCancel:
                return .cancelled
            case .userFallback:
                return .fallbackRequested
            case .biometryLockout:
                return .failed("Biometrics are locked. Please use your password.")
            case .biometryNotAvailable, .biometryNotEnrolled:
                return .failed("Biometric authentication isn't available on this device.")
            default:
                return .failed(error.localizedDescription)
            }
        } catch {
            return .failed(error.localizedDescription)
        }
    }
}
