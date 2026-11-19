//
//  PoseRepository.swift
//  YogaPoseLibrary
//
//  Single source of truth for pose data. Every ViewModel observes this
//  object, so changes (add / edit / delete / practise) are reflected on all
//  screens immediately.
//

import Foundation
import OSLog

@MainActor
final class PoseRepository: ObservableObject {

    @Published private(set) var poses: [Pose] = []

    private let storage: PoseStoring
    private let logger = Logger(subsystem: "com.example.YogaPoseLibrary", category: "PoseRepository")

    init(storage: PoseStoring = PoseStorageService()) {
        self.storage = storage
        if let stored = try? storage.load() {
            poses = stored
        } else {
            poses = SamplePoseData.make()
            persist()
        }
    }

    // MARK: - Queries

    func pose(withID id: UUID) -> Pose? {
        poses.first { $0.id == id }
    }

    // MARK: - Commands

    func add(_ pose: Pose) {
        poses.append(pose)
        persist()
    }

    func update(_ pose: Pose) {
        guard let index = poses.firstIndex(where: { $0.id == pose.id }) else { return }
        poses[index] = pose
        persist()
    }

    func delete(id: UUID) {
        poses.removeAll { $0.id == id }
        persist()
    }

    /// Increments the practice count and records the practice date.
    func markPracticed(id: UUID, on date: Date = Date()) {
        guard let index = poses.firstIndex(where: { $0.id == id }) else { return }
        poses[index].practiceCount += 1
        poses[index].lastPracticedDate = date
        persist()
    }

    // MARK: - Persistence

    private func persist() {
        do {
            try storage.save(poses)
        } catch {
            logger.error("Failed to save poses: \(error.localizedDescription)")
        }
    }
}
