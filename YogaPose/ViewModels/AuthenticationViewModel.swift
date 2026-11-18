
import Foundation
import LocalAuthentication
import Combine

@MainActor
class AuthenticationViewModel: ObservableObject {

    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    @Published var showPasswordLogin = false

    func authenticateWithFaceID() {

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {

            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock Yoga Pose Library"
            ) { success, authenticationError in

                Task { @MainActor in

                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.errorMessage =
                            authenticationError?.localizedDescription
                            ?? "Authentication failed"

                        self.showPasswordLogin = true
                    }
                }
            }

        } else {
            errorMessage = "Face ID is not available"
            showPasswordLogin = true
        }
    }

    func login(username: String, password: String) {

        if username.trimmingCharacters(
            in: .whitespaces
        ).isEmpty {
            errorMessage = "Please enter username"
            return
        }

        if password.count < 6 {
            errorMessage = "Password must contain at least 6 characters"
            return
        }

        errorMessage = ""
        isAuthenticated = true
    }
}
