//
//  PoseDetailViewModel.swift
//  YogaPoseLibrary
//
//  Tracks a single pose so the detail screen updates after edits or practice.
//

import Foundation
import Combine

@MainActor
final class PoseDetailViewModel: ObservableObject {

    /// `nil` once the pose has been deleted.
    @Published private(set) var pose: Pose?

    private let poseID: UUID
    private let repository: PoseRepository
    private var cancellables = Set<AnyCancellable>()

    init(poseID: UUID, repository: PoseRepository) {
        self.poseID = poseID
        self.repository = repository
        repository.$poses
            .map { poses in poses.first { $0.id == poseID } }
            .sink { [weak self] in self?.pose = $0 }
            .store(in: &cancellables)
    }

    func markPracticed() {
        repository.markPracticed(id: poseID)
    }

    func delete() {
        repository.delete(id: poseID)
    }
}
