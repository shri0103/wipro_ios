//
//  BadgeViews.swift
//  YogaPoseLibrary
//

import SwiftUI

/// Coloured capsule showing a difficulty level.
struct DifficultyBadge: View {
    let level: DifficultyLevel

    var body: some View {
        Text(level.rawValue)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .foregroundStyle(level.tint)
            .background(level.tint.opacity(0.15), in: Capsule())
    }
}

/// Orange capsule used to highlight poses that have never been practised.
struct NeverPracticedBadge: View {
    var body: some View {
        Label("Never Practised", systemImage: "sparkles")
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .foregroundStyle(.orange)
            .background(Color.orange.opacity(0.15), in: Capsule())
    }
}
