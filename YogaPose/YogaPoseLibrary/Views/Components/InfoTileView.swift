//
//  InfoTileView.swift
//  YogaPoseLibrary
//

import SwiftUI

/// Small tile with an icon, value and caption (hold time, practice count…).
struct InfoTileView: View {
    let iconName: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: iconName)
                .foregroundStyle(Color.accentColor)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .accessibilityElement(children: .combine)
    }
}
