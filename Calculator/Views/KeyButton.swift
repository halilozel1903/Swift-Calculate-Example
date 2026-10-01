//
//  KeyButton.swift
//  Calculator
//

import SwiftUI

/// Styled button used by the calculator keypad.
struct KeyButton: View {
    let key: CalculatorKey
    let titleOverride: String?
    let action: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(key: CalculatorKey, titleOverride: String? = nil, action: @escaping () -> Void) {
        self.key = key
        self.titleOverride = titleOverride
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(titleOverride ?? key.label)
                .font(font)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .accessibilityLabel(key.accessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }

    private var font: Font {
        dynamicTypeSize.isAccessibilitySize
            ? .title3
            : .title2
    }

    private var tint: Color {
        if key.isPrimaryAction {
            return .orange
        }
        if key.isUtility {
            return .secondary
        }
        switch key {
        case .operation, .constantPi, .constantE:
            return .indigo
        default:
            return .blue.opacity(0.85)
        }
    }
}
