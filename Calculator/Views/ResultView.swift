//
//  ResultView.swift
//  Calculator
//

import SwiftUI

/// Shows the result of the last calculation, or why it failed.
struct ResultView: View {
    let resultText: String?
    let errorMessage: String?
    let operation: CalculatorOperation?

    var body: some View {
        VStack(spacing: 8) {
            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            } else {
                Text("Result")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(resultText ?? "—")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(.snappy, value: resultText)
                    .textSelection(.enabled)

                if let operation, resultText != nil {
                    Text(operation.accessibilityName)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
        .accessibilityElement(children: .combine)
    }
}

#Preview("Result") {
    ResultView(resultText: "42", errorMessage: nil, operation: .addition)
        .padding()
}

#Preview("Error") {
    ResultView(
        resultText: nil,
        errorMessage: CalculatorError.divisionByZero.localizedDescription,
        operation: nil
    )
    .padding()
}
