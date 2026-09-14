//
//  CalculatorOperation.swift
//  Calculator
//

/// The arithmetic operations the calculator supports.
enum CalculatorOperation: String, CaseIterable, Identifiable, Sendable {
    case addition
    case subtraction
    case multiplication
    case division

    var id: String { rawValue }

    /// Symbol shown on the operation button.
    var symbol: String {
        switch self {
        case .addition: "+"
        case .subtraction: "\u{2212}"
        case .multiplication: "\u{00D7}"
        case .division: "\u{00F7}"
        }
    }

    /// Spoken name used as the button's accessibility label.
    var accessibilityName: String {
        switch self {
        case .addition: "Add"
        case .subtraction: "Subtract"
        case .multiplication: "Multiply"
        case .division: "Divide"
        }
    }
}
