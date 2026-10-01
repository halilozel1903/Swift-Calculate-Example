//
//  KeypadView.swift
//  Calculator
//

import SwiftUI

/// Standard and scientific calculator keypad layouts.
struct KeypadView: View {
    let clearTitle: String
    let showsScientific: Bool
    let onKey: (CalculatorKey) -> Void

    private let basicRows: [[CalculatorKey]] = [
        [.allClear, .operation(.negate), .operation(.percent), .operation(.division)],
        [.digit(7), .digit(8), .digit(9), .operation(.multiplication)],
        [.digit(4), .digit(5), .digit(6), .operation(.subtraction)],
        [.digit(1), .digit(2), .digit(3), .operation(.addition)],
        [.digit(0), .decimal, .equals]
    ]

    private let scientificRows: [[CalculatorKey]] = [
        [.operation(.squareRoot), .operation(.square), .operation(.reciprocal), .operation(.power)],
        [.operation(.sine), .operation(.cosine), .operation(.tangent), .constantPi],
        [.operation(.naturalLog), .operation(.log10), .operation(.exp), .constantE],
        [.operation(.tenPow)]
    ]

    var body: some View {
        VStack(spacing: 10) {
            if showsScientific {
                ForEach(Array(scientificRows.enumerated()), id: \.offset) { _, row in
                    keyRow(row)
                }
            }

            ForEach(Array(basicRows.enumerated()), id: \.offset) { _, row in
                keyRow(row)
            }
        }
    }

    @ViewBuilder
    private func keyRow(_ row: [CalculatorKey]) -> some View {
        HStack(spacing: 10) {
            ForEach(Array(row.enumerated()), id: \.offset) { _, key in
                let resolved = resolved(key)
                KeyButton(
                    key: resolved,
                    titleOverride: titleOverride(for: resolved)
                ) {
                    onKey(resolved)
                }
                .frame(minHeight: 56)
                .layoutPriority(keyPriority(resolved))
            }
        }
    }

    private func resolved(_ key: CalculatorKey) -> CalculatorKey {
        if case .allClear = key {
            return clearTitle == "C" ? .clear : .allClear
        }
        return key
    }

    private func titleOverride(for key: CalculatorKey) -> String? {
        switch key {
        case .clear, .allClear:
            clearTitle
        default:
            nil
        }
    }

    private func keyPriority(_ key: CalculatorKey) -> Double {
        if case .digit(0) = key { return 2 }
        return 1
    }
}

#Preview {
    KeypadView(clearTitle: "AC", showsScientific: true, onKey: { _ in })
        .padding()
}
