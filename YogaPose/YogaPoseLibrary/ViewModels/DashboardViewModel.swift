//
//  DashboardViewModel.swift
//  YogaPoseLibrary
//
//  Computes the summary figures shown on the home screen.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    @Published private(set) var poses: [Pose] = []
    private var cancellables = Set<AnyCancellable>()

    init(repository: PoseRepository) {
        repository.$poses
            .sink { [weak self] in self?.poses = $0 }
            .store(in: &cancellables)
    }

    var totalPoses: Int { poses.count }

    /// Number of distinct categories that currently contain at least one pose.
    var totalCategories: Int { Set(poses.map(\.category)).count }

    /// Poses practised at least once during the current calendar week.
    var practisedThisWeek: Int {
        guard let week = Calendar.current.dateInterval(of: .weekOfYear, for: Date()) else { return 0 }
        return poses.filter { pose in
            guard let date = pose.lastPracticedDate else { return false }
            return week.contains(date)
        }.count
    }

    var neverPracticedCount: Int { poses.filter(\.isNeverPracticed).count }

    /// The five most recently added poses.
    var recentPoses: [Pose] {
        Array(poses.sorted { $0.dateAdded > $1.dateAdded }.prefix(5))
    }
}
