//
//  RootView.swift
//  YogaPoseLibrary
//
//  Chooses between the authentication flow (inside a NavigationStack)
//  and the main tab interface.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var authViewModel: AuthViewModel
    let repository: PoseRepository

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView(repository: repository, authViewModel: authViewModel)
                    .transition(.opacity)
            } else {
                NavigationStack {
                    LoginView(viewModel: authViewModel)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
    }
}
