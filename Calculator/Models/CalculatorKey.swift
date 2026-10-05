//
//  CalculatorKey.swift
//  Calculator
//

/// A single keypad button.
nonisolated enum CalculatorKey: Hashable, Sendable {
    case digit(Int)
    case decimal
    case operation(CalculatorOperation)
    case equals
    case clear
    case allClear
    case constantPi
    case constantE

    var label: String {
        switch self {
        case .digit(let value): String(value)
        case .decimal: "."
        case .operation(let operation): operation.symbol
        case .equals: "="
        case .clear: "C"
        case .allClear: "AC"
        case .constantPi: "\u{03C0}"
        case .constantE: "e"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .digit(let value): String(value)
        case .decimal: "Decimal point"
        case .operation(let operation): operation.accessibilityName
        case .equals: "Equals"
        case .clear: "Clear"
        case .allClear: "All clear"
        case .constantPi: "Pi"
        case .constantE: "Euler's number"
        }
    }

    var isPrimaryAction: Bool {
        if case .equals = self { return true }
        if case .operation(let operation) = self, operation.isBinary { return true }
        return false
    }

    var isUtility: Bool {
        switch self {
        case .clear, .allClear, .operation(.percent), .operation(.negate):
            true
        default:
            false
        }
    }
}
