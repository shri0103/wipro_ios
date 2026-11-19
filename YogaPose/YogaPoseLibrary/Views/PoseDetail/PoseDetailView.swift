//
//  PoseDetailView.swift
//  YogaPoseLibrary
//
//  Full information about a pose, plus the Practice Counter,
//  Edit and Delete actions.
//

import SwiftUI

struct PoseDetailView: View {
    @StateObject private var viewModel: PoseDetailViewModel
    private let repository: PoseRepository

    @Environment(\.dismiss) private var dismiss
    @State private var showingEditForm = false
    @State private var showingDeleteAlert = false

    init(poseID: UUID, repository: PoseRepository) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: PoseDetailViewModel(poseID: poseID, repository: repository))
    }

    var body: some View {
        Group {
            if let pose = viewModel.pose {
                detail(for: pose)
            } else {
                ContentUnavailableView("Pose Not Found", systemImage: "questionmark.circle")
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.pose?.name ?? "Pose")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit", systemImage: "pencil") { showingEditForm = true }
                    Button("Delete", systemImage: "trash", role: .destructive) { showingDeleteAlert = true }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .disabled(viewModel.pose == nil)
                .accessibilityLabel("More actions")
            }
        }
        .sheet(isPresented: $showingEditForm) {
            if let pose = viewModel.pose {
                PoseFormView(repository: repository, mode: .edit(pose))
            }
        }
        .alert("Delete Pose?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.delete()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This pose will be permanently removed from your library.")
        }
    }

    // MARK: - Content

    private func detail(for pose: Pose) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                header(for: pose)

                HStack(spacing: 10) {
                    InfoTileView(iconName: "timer", title: "Hold Time", value: pose.holdTimeDescription)
                    InfoTileView(iconName: "repeat", title: "Practised",
                                 value: "\(pose.practiceCount)×")
                    InfoTileView(iconName: "calendar", title: "Last Practised",
                                 value: pose.lastPracticedDate.map { $0.formatted(date: .abbreviated, time: .omitted) } ?? "Never")
                }

                if pose.isNeverPracticed {
                    NeverPracticedBadge()
                }

                sectionCard(title: "Benefits", iconName: "heart.fill", tint: .pink, text: pose.benefits)
                sectionCard(title: "Precautions", iconName: "exclamationmark.triangle.fill", tint: .orange, text: pose.precautions)

                Button {
                    viewModel.markPracticed()
                } label: {
                    Label("Practised Today", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .sensoryFeedback(.success, trigger: pose.practiceCount)
            }
            .padding()
        }
    }

    private func header(for pose: Pose) -> some View {
        VStack(spacing: 10) {
            CategoryIconView(category: pose.category, size: 84)
            Text(pose.name)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            if !pose.sanskritName.isEmpty {
                Text(pose.sanskritName)
                    .font(.title3)
                    .italic()
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 8) {
                Label(pose.category.rawValue, systemImage: pose.category.iconName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                DifficultyBadge(level: pose.difficulty)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private func sectionCard(title: String, iconName: String, tint: Color, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: iconName)
                .font(.headline)
                .foregroundStyle(tint)
            Text(text.isEmpty ? "Not provided." : text)
                .font(.body)
                .foregroundStyle(text.isEmpty ? .secondary : .primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}
