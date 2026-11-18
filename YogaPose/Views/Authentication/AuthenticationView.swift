
import SwiftUI

struct AuthenticationView: View {

    @StateObject private var viewModel = AuthenticationViewModel()
    @StateObject private var poseViewModel = PoseLibraryViewModel()

    @State private var username = ""
    @State private var password = ""

    var body: some View {
        Group {
            if viewModel.isAuthenticated {

                DashboardView()
                    .environmentObject(poseViewModel)

            } else {

                VStack(spacing: 25) {

                    Spacer()

                    Image(systemName: "figure.mind.and.body")
                        .font(.system(size: 65))
                        .foregroundColor(.green)

                    Text("Yoga Pose Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Find your balance. Build your strength.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button {
                        viewModel.authenticateWithFaceID()
                    } label: {
                        Label("Continue with Face ID", systemImage: "faceid")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    if viewModel.showPasswordLogin {

                        VStack(spacing: 15) {

                            Text("Login with Username")
                                .font(.headline)

                            TextField("Enter username", text: $username)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)

                            SecureField("Enter password", text: $password)
                                .textFieldStyle(.roundedBorder)

                            Button("Login") {
                                viewModel.login(
                                    username: username,
                                    password: password
                                )
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                }
                .padding(25)
            }
        }
        .onAppear {
            if !viewModel.isAuthenticated {
                viewModel.authenticateWithFaceID()
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
