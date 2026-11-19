//
//  DashboardView.swift
//  YogaPoseLibrary
//
//  Home screen: library overview and navigation entry point.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    private let repository: PoseRepository
    private let authViewModel: AuthViewModel
    private let onShowLibrary: () -> Void

    @State private var showingSettings = false
    @State private var showingLogoutAlert = false

    init(repository: PoseRepository, authViewModel: AuthViewModel, onShowLibrary: @escaping () -> Void) {
        self.repository = repository
        self.authViewModel = authViewModel
        self.onShowLibrary = onShowLibrary
        _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: repository))
    }

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Namaste 🙏")
                        .font(.title2.weight(.semibold))

                    LazyVGrid(columns: columns, spacing: 12) {
                        StatCardView(title: "Total Poses", value: viewModel.totalPoses,
                                     iconName: "figure.yoga", tint: .teal)
                        StatCardView(title: "Categories", value: viewModel.totalCategories,
                                     iconName: "square.grid.2x2.fill", tint: .purple)
                        StatCardView(title: "Practised This Week", value: viewModel.practisedThisWeek,
                                     iconName: "checkmark.seal.fill", tint: .green)
                        StatCardView(title: "Never Practised", value: viewModel.neverPracticedCount,
                                     iconName: "sparkles", tint: .orange)
                    }

                    recentSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel("Settings")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        showingLogoutAlert = true
                    }
                    .accessibilityLabel("Logout")
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: authViewModel)
            }
            .alert("Log Out?", isPresented: $showingLogoutAlert) {
                Button("Log Out", role: .destructive) {
                    authViewModel.logout()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You will need to log in again to open your pose library.")
            }
            .navigationDestination(for: UUID.self) { id in
                PoseDetailView(poseID: id, repository: repository)
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recently Added")
                    .font(.headline)
                Spacer()
                Button("View All", action: onShowLibrary)
                    .font(.subheadline)
            }

            if viewModel.recentPoses.isEmpty {
                Text("No poses yet. Add your first pose from the Poses tab.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.recentPoses) { pose in
                    NavigationLink(value: pose.id) {
                        PoseCardView(pose: pose)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
