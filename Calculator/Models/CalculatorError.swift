//
//  CalculatorError.swift
//  Calculator
//

import Foundation

/// Errors produced while parsing operands or evaluating an operation.
enum CalculatorError: Error, Equatable, Sendable {
    /// The text in one of the operand fields is empty or not a number.
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
            "Enter a number in the first field."
        case .invalidOperand(.second):
            "Enter a number in the second field."
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
