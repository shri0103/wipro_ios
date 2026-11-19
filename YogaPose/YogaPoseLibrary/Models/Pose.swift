//
//  Pose.swift
//  YogaPoseLibrary
//
//  Core data models: Pose, PoseCategory and DifficultyLevel.
//

import Foundation

/// The five categories a pose can belong to.
enum PoseCategory: String, Codable, CaseIterable, Identifiable {
    case standing = "Standing"
    case seated = "Seated"
    case balancing = "Balancing"
    case backbend = "Backbend"
    case relaxation = "Relaxation"

    var id: String { rawValue }
}

/// How demanding a pose is.
enum DifficultyLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { rawValue }
}

/// A single yoga pose stored in the library.
struct Pose: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var sanskritName: String
    var category: PoseCategory
    var difficulty: DifficultyLevel
    /// Recommended hold time in seconds.
    var holdTimeSeconds: Int
    var benefits: String
    var precautions: String
    /// How many times the user has tapped "Practised Today".
    var practiceCount: Int
    var lastPracticedDate: Date?
    let dateAdded: Date

    init(
        id: UUID = UUID(),
        name: String,
        sanskritName: String = "",
        category: PoseCategory,
        difficulty: DifficultyLevel,
        holdTimeSeconds: Int,
        benefits: String = "",
        precautions: String = "",
        practiceCount: Int = 0,
        lastPracticedDate: Date? = nil,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.sanskritName = sanskritName
        self.category = category
        self.difficulty = difficulty
        self.holdTimeSeconds = holdTimeSeconds
        self.benefits = benefits
        self.precautions = precautions
        self.practiceCount = practiceCount
        self.lastPracticedDate = lastPracticedDate
        self.dateAdded = dateAdded
    }

    /// `true` while the pose has never been practised (used for highlighting).
    var isNeverPracticed: Bool { practiceCount == 0 }

    /// Human readable hold time, e.g. "45 sec" or "1 min 30 sec".
    var holdTimeDescription: String { Pose.formatHoldTime(holdTimeSeconds) }

    static func formatHoldTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainder = seconds % 60
        switch (minutes, remainder) {
        case (0, _): return "\(remainder) sec"
        case (_, 0): return "\(minutes) min"
        default: return "\(minutes) min \(remainder) sec"
        }
    }
}
