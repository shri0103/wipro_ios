//
//  BiometricPreferenceStore.swift
//  YogaPoseLibrary
//
//  Remembers WHICH account (if any) the user has chosen to unlock with Face ID.
//  Nothing is enabled until the user switches it on in Settings.
//

import Foundation

protocol BiometricPreferenceStoring {
    /// The account that has Face ID login enabled, or `nil` if none.
    var enabledUserID: UUID? { get }
    func enable(for userID: UUID)
    func disable()
}

struct BiometricPreferenceStore: BiometricPreferenceStoring {

    private let defaults: UserDefaults
    private let key = "yoga.faceIDEnabledUserID"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var enabledUserID: UUID? {
        guard let value = defaults.string(forKey: key) else { return nil }
        return UUID(uuidString: value)
    }

    func enable(for userID: UUID) {
        defaults.set(userID.uuidString, forKey: key)
    }

    func disable() {
        defaults.removeObject(forKey: key)
    }
}
