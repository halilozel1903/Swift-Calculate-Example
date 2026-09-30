//
//  CalculatorEngine.swift
//  Calculator
//

import Foundation

/// Parses user input, evaluates operations and formats results.
///
/// The engine is a value type without any UI dependency, so it can be unit
/// tested on its own and used from any isolation domain.
struct CalculatorEngine: Sendable {
    /// Locale used to read and write decimal separators.
    let locale: Locale

    /// Largest number of fraction digits shown in a formatted result.
    private let maximumFractionLength = 8

    init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }

    /// Evaluates a binary `operation` on the raw text of both operand fields.
    func evaluate(
        _ operation: CalculatorOperation,
        firstOperandText: String,
        secondOperandText: String
    ) throws(CalculatorError) -> Double {
        guard operation.isBinary else {
            throw CalculatorError.invalidOperand(.current)
        }
        let lhs = try operand(from: firstOperandText, at: .first)
        let rhs = try operand(from: secondOperandText, at: .second)
        return try apply(operation, lhs: lhs, rhs: rhs)
    }

    /// Applies a binary or unary `operation` to numeric operands.
    func apply(
        _ operation: CalculatorOperation,
        lhs: Double,
        rhs: Double = 0
    ) throws(CalculatorError) -> Double {
        let value: Double = switch operation {
        case .addition:
            lhs + rhs
        case .subtraction:
            lhs - rhs
        case .multiplication:
            lhs * rhs
        case .division:
            if rhs == 0 {
                throw CalculatorError.divisionByZero
            } else {
                lhs / rhs
            }
        case .power:
            pow(lhs, rhs)
        case .percent:
            lhs / 100
        case .negate:
            -lhs
        case .squareRoot:
            if lhs < 0 {
                throw CalculatorError.domainError
            } else {
                sqrt(lhs)
            }
        case .square:
            lhs * lhs
        case .reciprocal:
            if lhs == 0 {
                throw CalculatorError.divisionByZero
            } else {
                1 / lhs
            }
        case .sine:
            sin(lhs)
        case .cosine:
            cos(lhs)
        case .tangent:
            tan(lhs)
        case .naturalLog:
            if lhs <= 0 {
                throw CalculatorError.domainError
            } else {
                log(lhs)
            }
        case .log10:
            if lhs <= 0 {
                throw CalculatorError.domainError
            } else {
                log10(lhs)
            }
        case .exp:
            exp(lhs)
        case .tenPow:
            pow(10, lhs)
        }

        guard value.isFinite else { throw CalculatorError.resultUnrepresentable }
        return value
    }

    /// Applies `operation` to two numbers.
    func result(
        of operation: CalculatorOperation,
        lhs: Double,
        rhs: Double
    ) throws(CalculatorError) -> Double {
        try apply(operation, lhs: lhs, rhs: rhs)
    }

    /// Reads a finite number out of user supplied text.
    ///
    /// A lone `,` or `.` is always read as a decimal separator, so `"1,5"` and
    /// `"1.5"` mean the same thing regardless of the device language. Input
    /// that mixes both separators, or that uses non-ASCII digits, is parsed
    /// with ``locale``.
    func operand(
        from text: String,
        at position: CalculatorError.Operand
    ) throws(CalculatorError) -> Double {
        let trimmed = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\u{2212}", with: "-")
        guard !trimmed.isEmpty else { throw CalculatorError.invalidOperand(position) }

        guard let value = number(from: trimmed), value.isFinite else {
            throw CalculatorError.invalidOperand(position)
        }
        return value
    }

    private func number(from text: String) -> Double? {
        let usesBothSeparators = text.contains(",") && text.contains(".")
        if !usesBothSeparators, let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            return value
        }

        let strategy = FloatingPointFormatStyle<Double>.number.locale(locale).parseStrategy
        return try? strategy.parse(text)
    }

    /// Formats a result for display, dropping a trailing `.0`.
    func formatted(_ value: Double) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(0...maximumFractionLength))
                .locale(locale)
        )
    }

    /// Decimal separator preferred by ``locale``.
    var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
}
