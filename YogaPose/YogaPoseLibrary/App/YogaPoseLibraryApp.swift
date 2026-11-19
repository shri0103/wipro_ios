//
//  YogaPoseLibraryApp.swift
//  YogaPoseLibrary
//
//  App entry point. Creates the shared repository and authentication
//  view model once and injects them into the view hierarchy.
//

import SwiftUI

@main
struct YogaPoseLibraryApp: App {
    @StateObject private var repository = PoseRepository()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(authViewModel: authViewModel, repository: repository)
        }
    }
}
