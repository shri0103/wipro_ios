//
//  Theme.swift
//  YogaPoseLibrary
//
//  UI-only extensions (icons and colours) so the Models stay free of SwiftUI.
//

import SwiftUI

extension PoseCategory {
    /// Lightweight SF Symbol used instead of bitmap thumbnails.
    var iconName: String {
        switch self {
        case .standing: return "figure.stand"
        case .seated: return "figure.mind.and.body"
        case .balancing: return "figure.yoga"
        case .backbend: return "figure.flexibility"
        case .relaxation: return "figure.cooldown"
        }
    }

    var tint: Color {
        switch self {
        case .standing: return .blue
        case .seated: return .purple
        case .balancing: return .teal
        case .backbend: return .pink
        case .relaxation: return .indigo
        }
    }
}

extension DifficultyLevel {
    var tint: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}
