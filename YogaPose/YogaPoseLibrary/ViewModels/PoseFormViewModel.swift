//
//  PoseFormViewModel.swift
//  YogaPoseLibrary
//
//  Shared logic for the Add Pose and Edit Pose screens.
//

import Foundation

@MainActor
final class PoseFormViewModel: ObservableObject {

    enum Mode {
        case add
        case edit(Pose)
    }

    // MARK: - Form fields

    @Published var name = ""
    @Published var sanskritName = ""
    @Published var category: PoseCategory = .standing
    @Published var difficulty: DifficultyLevel = .beginner
    @Published var holdTimeSeconds = 30
    @Published var benefits = ""
    @Published var precautions = ""
    @Published var errorMessage: String?

    let mode: Mode
    private let repository: PoseRepository

    init(mode: Mode, repository: PoseRepository) {
        self.mode = mode
        self.repository = repository

        if case .edit(let pose) = mode {
            name = pose.name
            sanskritName = pose.sanskritName
            category = pose.category
            difficulty = pose.difficulty
            holdTimeSeconds = pose.holdTimeSeconds
            benefits = pose.benefits
            precautions = pose.precautions
        }
    }

    // MARK: - Display helpers

    var screenTitle: String {
        switch mode {
        case .add: return "Add Pose"
        case .edit: return "Edit Pose"
        }
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Saving

    /// Validates and stores the pose. Returns `true` when the form can be dismissed.
    func save() -> Bool {
        errorMessage = nil
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Pose name cannot be empty."
            return false
        }

        let editingID: UUID?
        if case .edit(let pose) = mode { editingID = pose.id } else { editingID = nil }

        let isDuplicate = repository.poses.contains {
            $0.id != editingID && $0.name.caseInsensitiveCompare(trimmedName) == .orderedSame
        }
        guard !isDuplicate else {
            errorMessage = "A pose named \"\(trimmedName)\" already exists."
            return false
        }

        let cleanSanskrit = sanskritName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanBenefits = benefits.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPrecautions = precautions.trimmingCharacters(in: .whitespacesAndNewlines)

        switch mode {
        case .add:
            repository.add(Pose(
                name: trimmedName,
                sanskritName: cleanSanskrit,
                category: category,
                difficulty: difficulty,
                holdTimeSeconds: holdTimeSeconds,
                benefits: cleanBenefits,
                precautions: cleanPrecautions
            ))
        case .edit(let original):
            // Use the latest stored copy so practice stats are never overwritten.
            var updated = repository.pose(withID: original.id) ?? original
            updated.name = trimmedName
            updated.sanskritName = cleanSanskrit
            updated.category = category
            updated.difficulty = difficulty
            updated.holdTimeSeconds = holdTimeSeconds
            updated.benefits = cleanBenefits
            updated.precautions = cleanPrecautions
            repository.update(updated)
        }
        return true
    }
}
