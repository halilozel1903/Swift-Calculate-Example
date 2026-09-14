//
//  CalculatorEngine.swift
//  Calculator
//

import Foundation

/// Parses user input, evaluates an operation and formats the result.
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

    /// Evaluates `operation` on the raw text of both operand fields.
    func evaluate(
        _ operation: CalculatorOperation,
        firstOperandText: String,
        secondOperandText: String
    ) throws(CalculatorError) -> Double {
        let lhs = try operand(from: firstOperandText, at: .first)
        let rhs = try operand(from: secondOperandText, at: .second)
        return try result(of: operation, lhs: lhs, rhs: rhs)
    }

    /// Applies `operation` to two numbers.
    func result(
        of operation: CalculatorOperation,
        lhs: Double,
        rhs: Double
    ) throws(CalculatorError) -> Double {
        let value: Double = switch operation {
        case .addition: lhs + rhs
        case .subtraction: lhs - rhs
        case .multiplication: lhs * rhs
        case .division:
            if rhs == 0 {
                throw CalculatorError.divisionByZero
            } else {
                lhs / rhs
            }
        }

        guard value.isFinite else { throw CalculatorError.resultUnrepresentable }
        return value
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
}
