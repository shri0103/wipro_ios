//
//  SettingsView.swift
//  YogaPoseLibrary
//
//  Account details and the Face ID on/off switch.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                if let user = viewModel.currentUser {
                    Section("Account") {
                        LabeledContent("Name", value: user.fullName)
                        LabeledContent("Username", value: user.username)
                        LabeledContent("Email", value: user.email)
                    }
                }

                Section {
                    Toggle(isOn: faceIDBinding) {
                        Label("Use \(viewModel.biometryName)", systemImage: viewModel.biometryIconName)
                    }
                    .disabled(viewModel.isAuthenticating
                              || (!viewModel.biometricAvailable && !viewModel.isBiometricEnabled))
                } header: {
                    Text("Security")
                } footer: {
                    if viewModel.biometricAvailable {
                        Text("When on, you can log in with \(viewModel.biometryName). Your password always works as a backup.")
                    } else {
                        Text("\(viewModel.biometryName) isn't available on this device. Set it up in the iOS Settings app to use it here.")
                    }
                }

                if let message = viewModel.settingsMessage {
                    Section {
                        Label(message, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear { viewModel.prepareSettings() }
        }
    }

    /// Reads the saved state and asks the view model to change it (which may show the Face ID prompt).
    private var faceIDBinding: Binding<Bool> {
        Binding(
            get: { viewModel.isBiometricEnabled },
            set: { newValue in
                Task { await viewModel.setBiometricEnabled(newValue) }
            }
        )
    }
}
