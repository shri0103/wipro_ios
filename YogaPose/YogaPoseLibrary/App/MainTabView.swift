//
//  MainTabView.swift
//  YogaPoseLibrary
//
//  Tab navigation: Dashboard (home) and the Pose Library.
//

import SwiftUI

enum AppTab: Hashable {
    case dashboard
    case library
}

struct MainTabView: View {
    let repository: PoseRepository
    let authViewModel: AuthViewModel

    @State private var selectedTab: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(
                repository: repository,
                authViewModel: authViewModel,
                onShowLibrary: { selectedTab = .library }
            )
            .tabItem { Label("Dashboard", systemImage: "square.grid.2x2") }
            .tag(AppTab.dashboard)

            PoseListView(repository: repository)
                .tabItem { Label("Poses", systemImage: "list.bullet.rectangle") }
                .tag(AppTab.library)
        }
    }
}
