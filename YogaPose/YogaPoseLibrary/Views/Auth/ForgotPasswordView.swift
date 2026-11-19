//
//  ForgotPasswordView.swift
//  YogaPoseLibrary
//
//  Lets a user choose a new password after confirming username + email.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @FocusState private var focusedField: ForgotPasswordField?
    @Environment(\.dismiss) private var dismiss

    private let onCompleted: () -> Void

    init(onCompleted: @escaping () -> Void) {
        self.onCompleted = onCompleted
    }

    var body: some View {
        Form {
            Section {
                Text("Enter the username and email address you registered with, then choose a new password.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .email }
            } header: {
                Text("Username")
            } footer: {
                errorText(for: .username)
            }

            Section {
                TextField("Email Address", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .newPassword }
            } header: {
                Text("Email Address")
            } footer: {
                errorText(for: .email)
            }

            Section {
                SecureField("New Password", text: $viewModel.newPassword)
                    .focused($focusedField, equals: .newPassword)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirmPassword }
            } header: {
                Text("New Password")
            } footer: {
                if let message = viewModel.error(for: .newPassword) {
                    Text(message).foregroundStyle(.red)
                } else {
                    Text("At least \(InputValidator.minPasswordLength) characters, with a letter and a number.")
                }
            }

            Section {
                SecureField("Confirm New Password", text: $viewModel.confirmPassword)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.done)
                    .onSubmit { submit() }
            } header: {
                Text("Confirm New Password")
            } footer: {
                errorText(for: .confirmPassword)
            }

            if let message = viewModel.generalError {
                Section {
                    Label(message, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }
            }

            Section {
                Button(action: submit) {
                    Text("Reset Password")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Password Updated", isPresented: $viewModel.showSuccess) {
            Button("Go to Login") {
                onCompleted()
                dismiss()
            }
        } message: {
            Text("Your password has been changed. Please log in with your new password.")
        }
    }

    // MARK: - Helpers

    private func submit() {
        focusedField = nil
        viewModel.submit()
    }

    @ViewBuilder
    private func errorText(for field: ForgotPasswordField) -> some View {
        if let message = viewModel.error(for: field) {
            Text(message).foregroundStyle(.red)
        }
    }
}
