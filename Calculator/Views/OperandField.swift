//
//  OperandField.swift
//  Calculator
//

import SwiftUI

/// Identifies the two operand fields for keyboard focus.
enum OperandFieldID: Hashable {
    case first
    case second
}

/// Labelled numeric input used for both operands.
struct OperandField: View {
    let title: LocalizedStringKey
    let id: OperandFieldID
    @Binding var text: String
    @FocusState.Binding var focus: OperandFieldID?

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
                .focused($focus, equals: id)
        }
    }
}
