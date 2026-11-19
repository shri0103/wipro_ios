//
//  SignUpView.swift
//  YogaPoseLibrary
//
//  New user registration form.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @FocusState private var focusedField: SignUpField?
    @Environment(\.dismiss) private var dismiss

    /// Called with the new username when the user taps "Go to Login".
    private let onRegistered: (String) -> Void

    init(onRegistered: @escaping (String) -> Void) {
        self.onRegistered = onRegistered
    }

    var body: some View {
        Form {
            Section {
                TextField("Full Name", text: $viewModel.fullName)
                    .textContentType(.name)
                    .focused($focusedField, equals: .fullName)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .username }
            } header: {
                Text("Full Name")
            } footer: {
                errorText(for: .fullName)
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
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
            } header: {
                Text("Email Address")
            } footer: {
                errorText(for: .email)
            }

            Section {
                SecureField("Password", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirmPassword }
            } header: {
                Text("Password")
            } footer: {
                if let message = viewModel.error(for: .password) {
                    Text(message).foregroundStyle(.red)
                } else {
                    Text("At least \(InputValidator.minPasswordLength) characters, with a letter and a number.")
                }
            }

            Section {
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.done)
                    .onSubmit { submit() }
            } header: {
                Text("Confirm Password")
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
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Account Created", isPresented: $viewModel.showSuccess) {
            Button("Go to Login") {
                onRegistered(viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines))
                dismiss()
            }
        } message: {
            Text("Your account has been created successfully. Please log in.")
        }
    }

    // MARK: - Helpers

    private func submit() {
        focusedField = nil
        viewModel.submit()
    }

    @ViewBuilder
    private func errorText(for field: SignUpField) -> some View {
        if let message = viewModel.error(for: field) {
            Text(message).foregroundStyle(.red)
        }
    }
}
