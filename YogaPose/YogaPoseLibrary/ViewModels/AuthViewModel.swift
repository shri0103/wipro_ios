//
//  AuthViewModel.swift
//  YogaPoseLibrary
//
//  Owns the login session, the login form and Face ID logic.
//  The session lives in memory only, so the user must authenticate on every launch.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Session

    /// The signed-in user, or `nil` when logged out.
    @Published private(set) var currentUser: UserAccount?

    var isAuthenticated: Bool { currentUser != nil }

    // MARK: - Login form

    @Published var identifier = ""
    @Published var password = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var noticeMessage: String?

    // MARK: - Face ID state

    /// The device supports and has set up Face ID / Touch ID.
    @Published private(set) var biometricAvailable = false
    /// The login screen should offer the Face ID button.
    @Published private(set) var biometricLoginAvailable = false
    /// The signed-in user has Face ID login switched on.
    @Published private(set) var isBiometricEnabled = false
    @Published private(set) var isAuthenticating = false
    @Published private(set) var settingsMessage: String?

    private let accountStore: AccountStoring
    private let biometricService: BiometricAuthenticating
    private let preferences: BiometricPreferenceStoring
    private var hasAttemptedLaunchPrompt = false

    init(
        accountStore: AccountStoring = AccountStore(),
        biometricService: BiometricAuthenticating = BiometricService(),
        preferences: BiometricPreferenceStoring = BiometricPreferenceStore()
    ) {
        self.accountStore = accountStore
        self.biometricService = biometricService
        self.preferences = preferences
        refreshBiometricState()
    }

    var biometryName: String { biometricService.biometryName }
    var biometryIconName: String { biometricService.biometryIconName }

    // MARK: - Password login

    /// Validates the form and signs the user in if the credentials are correct.
    func login() {
        errorMessage = nil
        noticeMessage = nil

        let trimmedIdentifier = identifier.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedIdentifier.isEmpty else {
            errorMessage = "Please enter your username or email."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        guard let user = accountStore.authenticate(identifier: trimmedIdentifier, password: password) else {
            errorMessage = "Incorrect username/email or password."
            password = ""
            return
        }

        completeLogin(user)
    }

    // MARK: - Face ID login

    /// Prompts for Face ID once when the app first opens (only if the user enabled it).
    func attemptLaunchBiometricLogin() async {
        guard !hasAttemptedLaunchPrompt else { return }
        hasAttemptedLaunchPrompt = true
        refreshBiometricState()
        guard biometricLoginAvailable else { return }
        await loginWithBiometrics()
    }

    /// Logs in the account that enabled Face ID. Password login always remains available.
    func loginWithBiometrics() async {
        guard !isAuthenticating, !isAuthenticated else { return }
        errorMessage = nil
        noticeMessage = nil
        refreshBiometricState()

        guard biometricLoginAvailable,
              let userID = preferences.enabledUserID,
              let user = accountStore.account(withID: userID) else {
            errorMessage = "Face ID login isn't set up. Please log in with your password."
            return
        }

        isAuthenticating = true
        let result = await biometricService.authenticate(reason: "Log in to your Yoga Pose Library")
        isAuthenticating = false

        switch result {
        case .success:
            completeLogin(user)
        case .cancelled:
            break
        case .fallbackRequested:
            noticeMessage = "Please log in with your password."
        case .failed(let message):
            errorMessage = message
        }
    }

    // MARK: - Face ID settings

    /// Turns Face ID login on (after the user confirms with Face ID) or off.
    func setBiometricEnabled(_ enabled: Bool) async {
        settingsMessage = nil
        guard let user = currentUser, !isAuthenticating else { return }

        guard enabled else {
            preferences.disable()
            refreshBiometricState()
            return
        }

        refreshBiometricState()
        guard biometricAvailable else {
            settingsMessage = "\(biometryName) isn't available or set up on this device."
            return
        }

        isAuthenticating = true
        let result = await biometricService.authenticate(reason: "Confirm to enable \(biometryName) login")
        isAuthenticating = false

        switch result {
        case .success:
            preferences.enable(for: user.id)
            refreshBiometricState()
        case .cancelled, .fallbackRequested:
            settingsMessage = "\(biometryName) login was not enabled."
        case .failed(let message):
            settingsMessage = message
        }
    }

    /// Clears old messages and re-checks Face ID when Settings opens.
    func prepareSettings() {
        settingsMessage = nil
        refreshBiometricState()
    }

    /// Re-reads device support and the saved preference.
    func refreshBiometricState() {
        biometricAvailable = biometricService.isAvailable
        let enabledID = preferences.enabledUserID

        if let enabledID, accountStore.account(withID: enabledID) != nil {
            biometricLoginAvailable = biometricAvailable
        } else {
            biometricLoginAvailable = false
        }
        isBiometricEnabled = (enabledID != nil) && (currentUser?.id == enabledID)
    }

    // MARK: - Session end

    /// Ends the session. Registered accounts and the Face ID choice are NOT deleted,
    /// so the same user can log in again (but must authenticate first).
    func logout() {
        currentUser = nil
        identifier = ""
        password = ""
        errorMessage = nil
        settingsMessage = nil
        noticeMessage = "You have been logged out."
        refreshBiometricState()
    }

    // MARK: - Messages from other screens

    /// Called after Sign Up succeeds: pre-fills the username and shows a notice.
    func registrationCompleted(username: String) {
        identifier = username
        password = ""
        errorMessage = nil
        noticeMessage = "Account created. Please log in."
    }

    /// Called after a password reset succeeds.
    func passwordResetCompleted() {
        password = ""
        errorMessage = nil
        noticeMessage = "Password updated. Please log in with your new password."
    }

    // MARK: - Private

    private func completeLogin(_ user: UserAccount) {
        currentUser = user
        identifier = ""
        password = ""
        errorMessage = nil
        noticeMessage = nil
        refreshBiometricState()
    }
}
