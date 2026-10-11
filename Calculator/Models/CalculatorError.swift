//
//  CalculatorError.swift
//  Calculator
//

import Foundation

/// Errors produced while parsing operands or evaluating an operation.
nonisolated enum CalculatorError: Error, Equatable, Sendable {
    /// An operand string is empty or not a number.
    case invalidOperand(Operand)
    /// A division where the divisor is zero.
    case divisionByZero
    /// The operation overflowed to infinity or produced a NaN.
    case resultUnrepresentable
    /// A real-valued function was given a domain it cannot handle.
    case domainError

    enum Operand: String, Sendable {
        case first
        case second
        case current
    }
}

extension CalculatorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidOperand(.first):
            "Enter the first number."
        case .invalidOperand(.second):
            "Enter the second number."
        case .invalidOperand(.current):
            "Enter a number."
        case .divisionByZero:
            "Cannot divide by zero."
        case .resultUnrepresentable:
            "The result is too large to display."
        case .domainError:
            "That value is outside the function's domain."
        }
    }
}
