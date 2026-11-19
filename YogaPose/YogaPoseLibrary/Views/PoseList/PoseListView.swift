//
//  PoseListView.swift
//  YogaPoseLibrary
//
//  Scrollable list of pose cards with search, filters, add and delete.
//

import SwiftUI

struct PoseListView: View {
    @StateObject private var viewModel: PoseListViewModel
    private let repository: PoseRepository

    @State private var showingAddForm = false
    @State private var poseToDelete: Pose?

    init(repository: PoseRepository) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: PoseListViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryChips
                content
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pose Library")
            .searchable(text: $viewModel.searchText, prompt: "Search by pose name")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { filterMenu }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Pose")
                }
            }
            .navigationDestination(for: UUID.self) { id in
                PoseDetailView(poseID: id, repository: repository)
            }
            .sheet(isPresented: $showingAddForm) {
                PoseFormView(repository: repository, mode: .add)
            }
            .alert("Delete Pose?", isPresented: deleteAlertBinding, presenting: poseToDelete) { pose in
                Button("Delete", role: .destructive) { viewModel.delete(pose) }
                Button("Cancel", role: .cancel) {}
            } message: { pose in
                Text("\"\(pose.name)\" will be permanently removed from your library.")
            }
        }
    }

    // MARK: - Subviews

    private var deleteAlertBinding: Binding<Bool> {
        Binding(
            get: { poseToDelete != nil },
            set: { if !$0 { poseToDelete = nil } }
        )
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChipView(title: "All", isSelected: viewModel.selectedCategory == nil) {
                    viewModel.selectedCategory = nil
                }
                ForEach(PoseCategory.allCases) { category in
                    FilterChipView(title: category.rawValue,
                                   isSelected: viewModel.selectedCategory == category) {
                        viewModel.selectedCategory = (viewModel.selectedCategory == category) ? nil : category
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    private var filterMenu: some View {
        Menu {
            Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                Text("All Levels").tag(DifficultyLevel?.none)
                ForEach(DifficultyLevel.allCases) { level in
                    Text(level.rawValue).tag(DifficultyLevel?.some(level))
                }
            }
            Button("Reset Filters", systemImage: "arrow.counterclockwise") {
                viewModel.resetFilters()
            }
            .disabled(!viewModel.hasActiveFilters)
        } label: {
            Image(systemName: viewModel.selectedDifficulty == nil
                  ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill")
        }
        .accessibilityLabel("Filter by difficulty")
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.filteredPoses.isEmpty {
            Spacer()
            if viewModel.hasActiveFilters {
                ContentUnavailableView("No Matching Poses",
                                       systemImage: "magnifyingglass",
                                       description: Text("Try a different search or filter."))
            } else {
                ContentUnavailableView("No Poses Yet",
                                       systemImage: "figure.yoga",
                                       description: Text("Tap + to add your first pose."))
            }
            Spacer()
        } else {
            List {
                ForEach(viewModel.filteredPoses) { pose in
                    NavigationLink(value: pose.id) {
                        PoseCardView(pose: pose)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.markPracticed(pose)
                        } label: {
                            Label("Practised", systemImage: "checkmark.circle.fill")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            poseToDelete = pose
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button {
                            viewModel.markPracticed(pose)
                        } label: {
                            Label("Practised Today", systemImage: "checkmark.circle")
                        }
                        Button(role: .destructive) {
                            poseToDelete = pose
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}
