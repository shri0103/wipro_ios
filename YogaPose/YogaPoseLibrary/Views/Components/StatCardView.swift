//
//  StatCardView.swift
//  YogaPoseLibrary
//

import SwiftUI

/// Large number with a title, used on the dashboard.
struct StatCardView: View {
    let title: String
    let value: Int
    let iconName: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: iconName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
            Text("\(value)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .accessibilityElement(children: .combine)
    }
}
