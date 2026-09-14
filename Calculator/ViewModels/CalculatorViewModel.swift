//
//  CalculatorViewModel.swift
//  Calculator
//

import Foundation
import Observation

/// Holds the calculator screen state and drives ``CalculatorEngine``.
@MainActor
@Observable
final class CalculatorViewModel {
    var firstOperandText = ""
    var secondOperandText = ""

    /// Formatted result of the last successful calculation.
    private(set) var resultText: String?

    /// Message describing why the last calculation failed.
    private(set) var errorMessage: String?

    /// Operation used for the last successful calculation.
    private(set) var lastOperation: CalculatorOperation?

    private let engine: CalculatorEngine

    init(engine: CalculatorEngine = CalculatorEngine()) {
        self.engine = engine
    }

    /// True when neither operand field has content.
    var isEmpty: Bool {
        firstOperandText.isEmpty && secondOperandText.isEmpty && resultText == nil
    }

    /// Evaluates `operation` and publishes either a result or an error message.
    func calculate(_ operation: CalculatorOperation) {
        do {
            let value = try engine.evaluate(
                operation,
                firstOperandText: firstOperandText,
                secondOperandText: secondOperandText
            )
            resultText = engine.formatted(value)
            lastOperation = operation
            errorMessage = nil
        } catch {
            resultText = nil
            lastOperation = nil
            errorMessage = error.localizedDescription
        }
    }

    /// Resets the operands, the result and any error.
    func clear() {
        firstOperandText = ""
        secondOperandText = ""
        resultText = nil
        errorMessage = nil
        lastOperation = nil
    }
}
