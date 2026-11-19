//
//  CategoryIconView.swift
//  YogaPoseLibrary
//

import SwiftUI

/// Rounded tinted tile showing the SF Symbol for a pose category.
struct CategoryIconView: View {
    let category: PoseCategory
    var size: CGFloat = 52

    var body: some View {
        Image(systemName: category.iconName)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(category.tint)
            .frame(width: size, height: size)
            .background(category.tint.opacity(0.15), in: RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
            .accessibilityHidden(true)
    }
}
