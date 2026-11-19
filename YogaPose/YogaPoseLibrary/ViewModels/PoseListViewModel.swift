//
//  PoseListViewModel.swift
//  YogaPoseLibrary
//
//  Search + filter logic for the pose list.
//

import Foundation
import Combine

@MainActor
final class PoseListViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var selectedCategory: PoseCategory?
    @Published var selectedDifficulty: DifficultyLevel?
    @Published private(set) var allPoses: [Pose] = []

    private let repository: PoseRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: PoseRepository) {
        self.repository = repository
        repository.$poses
            .sink { [weak self] in self?.allPoses = $0 }
            .store(in: &cancellables)
    }

    /// Poses matching the search text and the active filters, sorted A–Z.
    var filteredPoses: [Pose] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return allPoses
            .filter { pose in
                let matchesSearch = query.isEmpty
                    || pose.name.localizedCaseInsensitiveContains(query)
                    || pose.sanskritName.localizedCaseInsensitiveContains(query)
                let matchesCategory = selectedCategory == nil || pose.category == selectedCategory
                let matchesDifficulty = selectedDifficulty == nil || pose.difficulty == selectedDifficulty
                return matchesSearch && matchesCategory && matchesDifficulty
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var hasActiveFilters: Bool {
        selectedCategory != nil || selectedDifficulty != nil || !searchText.isEmpty
    }

    func resetFilters() {
        searchText = ""
        selectedCategory = nil
        selectedDifficulty = nil
    }

    func markPracticed(_ pose: Pose) {
        repository.markPracticed(id: pose.id)
    }

    func delete(_ pose: Pose) {
        repository.delete(id: pose.id)
    }
}
