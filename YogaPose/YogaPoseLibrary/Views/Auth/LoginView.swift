//
//  LoginView.swift
//  YogaPoseLibrary
//
//  Login screen: username or email + password, with links to
//  Forgot Password and Sign Up.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    private enum Field {
        case identifier
        case password
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.accentColor.opacity(0.25), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    header
                    biometricSection
                    loginForm
                    messages
                    links
                }
                .padding(24)
                .frame(maxWidth: 480)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { viewModel.refreshBiometricState() }
        .task { await viewModel.attemptLaunchBiometricLogin() }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.yoga")
                .font(.system(size: 64))
                .foregroundStyle(Color.accentColor)
                .padding(.top, 40)
            Text("Yoga Pose Library")
                .font(.largeTitle.bold())
            Text("Log in to open your private collection")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var biometricSection: some View {
        if viewModel.biometricLoginAvailable {
            VStack(spacing: 10) {
                Button {
                    Task { await viewModel.loginWithBiometrics() }
                } label: {
                    Label("Login with \(viewModel.biometryName)", systemImage: viewModel.biometryIconName)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(viewModel.isAuthenticating)

                Text("or use your password")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var loginForm: some View {
        VStack(spacing: 14) {
            TextField("Username or Email", text: $viewModel.identifier)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .focused($focusedField, equals: .identifier)
                .onSubmit { focusedField = .password }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))

            SecureField("Password", text: $viewModel.password)
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit { login() }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))

            Button(action: login) {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    @ViewBuilder
    private var messages: some View {
        if let notice = viewModel.noticeMessage {
            Label(notice, systemImage: "checkmark.circle.fill")
                .font(.footnote)
                .foregroundStyle(.green)
                .multilineTextAlignment(.center)
        }
        if let message = viewModel.errorMessage {
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .font(.footnote)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
    }

    private var links: some View {
        VStack(spacing: 12) {
            NavigationLink("Forgot Password?") {
                ForgotPasswordView(onCompleted: { viewModel.passwordResetCompleted() })
            }
            .font(.subheadline)

            HStack(spacing: 4) {
                Text("New here?")
                    .foregroundStyle(.secondary)
                NavigationLink("Sign Up") {
                    SignUpView(onRegistered: { viewModel.registrationCompleted(username: $0) })
                }
            }
            .font(.subheadline)
        }
    }

    // MARK: - Actions

    private func login() {
        focusedField = nil
        viewModel.login()
    }
}
