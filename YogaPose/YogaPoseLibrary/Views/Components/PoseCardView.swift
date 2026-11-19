//
//  PoseCardView.swift
//  YogaPoseLibrary
//

import SwiftUI

/// Card summarising a pose: name, category, difficulty and practice state.
struct PoseCardView: View {
    let pose: Pose

    var body: some View {
        HStack(spacing: 14) {
            CategoryIconView(category: pose.category)

            VStack(alignment: .leading, spacing: 4) {
                Text(pose.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !pose.sanskritName.isEmpty {
                    Text(pose.sanskritName)
                        .font(.caption)
                        .italic()
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 8) {
                    Label(pose.category.rawValue, systemImage: pose.category.iconName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    DifficultyBadge(level: pose.difficulty)
                }

                if pose.isNeverPracticed {
                    NeverPracticedBadge()
                } else {
                    Text("Practised \(pose.practiceCount) \(pose.practiceCount == 1 ? "time" : "times")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(pose.isNeverPracticed ? Color.orange.opacity(0.7) : Color.clear, lineWidth: 1.5)
        )
        .accessibilityElement(children: .combine)
    }
}
