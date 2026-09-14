//
//  OperandField.swift
//  Calculator
//

import SwiftUI

/// Labelled numeric input used for both operands.
struct OperandField: View {
    let title: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField(title, text: $text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .monospacedDigit()
        }
    }
}

#Preview {
    @Previewable @State var text = "42"
    OperandField(title: "First number", text: $text)
        .padding()
}
