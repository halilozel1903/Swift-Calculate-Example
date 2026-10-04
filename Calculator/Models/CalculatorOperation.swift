//
//  CalculatorOperation.swift
//  Calculator
//

/// Arithmetic and scientific operations the calculator supports.
nonisolated enum CalculatorOperation: String, CaseIterable, Identifiable, Sendable {
    // Binary
    case addition
    case subtraction
    case multiplication
    case division
    case power

    // Unary
    case percent
    case negate
    case squareRoot
    case square
    case reciprocal
    case sine
    case cosine
    case tangent
    case naturalLog
    case log10
    case exp
    case tenPow

    var id: String { rawValue }

    /// True when the operation needs two operands.
    var isBinary: Bool {
        switch self {
        case .addition, .subtraction, .multiplication, .division, .power:
            true
        default:
            false
        }
    }

    /// Symbol shown on keypad buttons and in history.
    var symbol: String {
        switch self {
        case .addition: "+"
        case .subtraction: "\u{2212}"
        case .multiplication: "\u{00D7}"
        case .division: "\u{00F7}"
        case .power: "x\u{207F}"
        case .percent: "%"
        case .negate: "+/\u{2212}"
        case .squareRoot: "\u{221A}"
        case .square: "x\u{00B2}"
        case .reciprocal: "1/x"
        case .sine: "sin"
        case .cosine: "cos"
        case .tangent: "tan"
        case .naturalLog: "ln"
        case .log10: "log"
        case .exp: "e\u{02E3}"
        case .tenPow: "10\u{02E3}"
        }
    }

    /// Spoken name used as the button's accessibility label.
    var accessibilityName: String {
        switch self {
        case .addition: "Add"
        case .subtraction: "Subtract"
        case .multiplication: "Multiply"
        case .division: "Divide"
        case .power: "Power"
        case .percent: "Percent"
        case .negate: "Change sign"
        case .squareRoot: "Square root"
        case .square: "Square"
        case .reciprocal: "Reciprocal"
        case .sine: "Sine"
        case .cosine: "Cosine"
        case .tangent: "Tangent"
        case .naturalLog: "Natural log"
        case .log10: "Log base 10"
        case .exp: "e to the x"
        case .tenPow: "10 to the x"
        }
    }
}
