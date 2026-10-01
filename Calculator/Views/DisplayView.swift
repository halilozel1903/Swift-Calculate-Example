//
//  DisplayView.swift
//  Calculator
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Shows the current expression, result and optional error.
struct DisplayView: View {
    let expressionText: String
    let displayText: String
    let errorMessage: String?
    let onCopy: () -> Void

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if !expressionText.isEmpty {
                Text(expressionText)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .accessibilityLabel("Expression \(expressionText)")
            }

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityLabel(errorMessage)
            } else {
                Text(displayText)
                    .font(.system(.largeTitle, design: .rounded, weight: .semibold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.35)
                    .contentTransition(.numericText())
                    .animation(.snappy, value: displayText)
                    .textSelection(.enabled)
                    .accessibilityLabel("Result \(displayText)")
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 20))
        .contextMenu {
            Button("Copy Result", systemImage: "doc.on.doc") {
                copyResult()
            }
            .disabled(errorMessage != nil)
        }
        .onTapGesture(count: 2, perform: copyResult)
        .accessibilityHint("Double tap or use the context menu to copy the result")
    }

    private func copyResult() {
        guard errorMessage == nil else { return }
        #if canImport(UIKit)
        UIPasteboard.general.string = displayText
        #endif
        onCopy()
    }
}

#Preview {
    DisplayView(
        expressionText: "12 ×",
        displayText: "144",
        errorMessage: nil,
        onCopy: {}
    )
    .padding()
}
