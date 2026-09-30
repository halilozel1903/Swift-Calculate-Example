//
//  CalculatorViewModel.swift
//  Calculator
//

import Foundation
import Observation

/// Drives a classic calculator keypad: display, pending op, history and errors.
@MainActor
@Observable
final class CalculatorViewModel {
    /// Text shown on the main display.
    private(set) var displayText = "0"

    /// Optional expression preview (for example `12 ×`).
    private(set) var expressionText = ""

    /// Message describing why the last calculation failed.
    private(set) var errorMessage: String?

    /// Completed calculations, newest first.
    private(set) var history: [CalculationHistoryEntry] = []

    /// True when the next digit should replace the display instead of appending.
    private var isTyping = false

    private var storedValue: Double?
    private var pendingOperation: CalculatorOperation?
    private let engine: CalculatorEngine
    private let historyStore: CalculationHistoryStore

    init(
        engine: CalculatorEngine = CalculatorEngine(),
        historyStore: CalculationHistoryStore = CalculationHistoryStore()
    ) {
        self.engine = engine
        self.historyStore = historyStore
        history = historyStore.load()
    }

    /// Legacy fields kept so older two-operand tests and call sites still compile
    /// while the keypad UI is the primary interface.
    var firstOperandText = ""
    var secondOperandText = ""
    private(set) var resultText: String?
    private(set) var lastOperation: CalculatorOperation?

    var isEmpty: Bool {
        displayText == "0"
            && expressionText.isEmpty
            && errorMessage == nil
            && storedValue == nil
            && pendingOperation == nil
            && firstOperandText.isEmpty
            && secondOperandText.isEmpty
            && resultText == nil
    }

    var clearKeyTitle: String {
        isTyping || displayText != "0" ? "C" : "AC"
    }

    // MARK: - Legacy two-field API

    /// Evaluates `operation` using the two operand text fields.
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
            appendHistory(
                expression: "\(firstOperandText) \(operation.symbol) \(secondOperandText)",
                result: resultText ?? ""
            )
        } catch {
            resultText = nil
            lastOperation = nil
            errorMessage = error.localizedDescription
        }
    }

    /// Resets operands, keypad state, result and any error.
    func clear() {
        firstOperandText = ""
        secondOperandText = ""
        resultText = nil
        lastOperation = nil
        resetKeypad(allClear: true)
    }

    // MARK: - Keypad API

    func input(_ key: CalculatorKey) {
        errorMessage = nil

        switch key {
        case .digit(let digit):
            inputDigit(digit)
        case .decimal:
            inputDecimal()
        case .operation(let operation):
            inputOperation(operation)
        case .equals:
            evaluatePending()
        case .clear:
            resetKeypad(allClear: false)
        case .allClear:
            resetKeypad(allClear: true)
        case .constantPi:
            setDisplay(value: .pi)
        case .constantE:
            setDisplay(value: exp(1))
        }
    }

    func clearHistory() {
        history = []
        historyStore.clear()
    }

    /// Loads a history result back onto the display.
    func restore(_ entry: CalculationHistoryEntry) {
        displayText = entry.result
        expressionText = entry.expression
        storedValue = nil
        pendingOperation = nil
        isTyping = false
        errorMessage = nil
        resultText = entry.result
    }

    func copyDisplayToPasteboard() -> String {
        displayText
    }

    // MARK: - Private

    private func inputDigit(_ digit: Int) {
        let next = String(digit)
        if isTyping {
            if displayText == "0" {
                displayText = next
            } else if displayText == "-0" {
                displayText = "-\(next)"
            } else {
                displayText += next
            }
        } else {
            displayText = next
            isTyping = true
        }
    }

    private func inputDecimal() {
        let separator = engine.decimalSeparator
        if !isTyping {
            displayText = "0\(separator)"
            isTyping = true
            return
        }
        guard !displayText.contains("."), !displayText.contains(",") else { return }
        displayText += separator
    }

    private func inputOperation(_ operation: CalculatorOperation) {
        if !operation.isBinary {
            applyUnary(operation)
            return
        }

        if isTyping || storedValue == nil {
            commitDisplayIntoStoredValue()
        } else if pendingOperation != nil {
            evaluatePending(keepTyping: false)
        }

        pendingOperation = operation
        expressionText = "\(engine.formatted(storedValue ?? 0)) \(operation.symbol)"
        isTyping = false
    }

    private func applyUnary(_ operation: CalculatorOperation) {
        do {
            let current = try currentDisplayValue()
            let value = try engine.apply(operation, lhs: current)
            let formatted = engine.formatted(value)
            displayText = formatted
            isTyping = false
            errorMessage = nil
            expressionText = "\(operation.symbol)(\(engine.formatted(current)))"
            appendHistory(expression: expressionText, result: formatted)
            expressionText = ""
        } catch {
            present(error)
        }
    }

    private func evaluatePending(keepTyping: Bool = false) {
        guard let operation = pendingOperation, let lhs = storedValue else {
            isTyping = keepTyping
            return
        }

        do {
            let rhs = try currentDisplayValue()
            let value = try engine.apply(operation, lhs: lhs, rhs: rhs)
            let formatted = engine.formatted(value)
            let expression = "\(engine.formatted(lhs)) \(operation.symbol) \(engine.formatted(rhs))"
            displayText = formatted
            storedValue = value
            pendingOperation = nil
            expressionText = ""
            isTyping = false
            errorMessage = nil
            lastOperation = operation
            resultText = formatted
            appendHistory(expression: expression, result: formatted)
        } catch {
            present(error)
        }
    }

    private func commitDisplayIntoStoredValue() {
        do {
            storedValue = try currentDisplayValue()
            errorMessage = nil
        } catch {
            present(error)
        }
    }

    private func currentDisplayValue() throws(CalculatorError) -> Double {
        try engine.operand(from: displayText, at: .current)
    }

    private func setDisplay(value: Double) {
        displayText = engine.formatted(value)
        isTyping = false
        errorMessage = nil
    }

    private func resetKeypad(allClear: Bool) {
        if allClear || (!isTyping && pendingOperation == nil && storedValue == nil) {
            storedValue = nil
            pendingOperation = nil
            expressionText = ""
        }
        displayText = "0"
        isTyping = false
        errorMessage = nil
    }

    private func present(_ error: Error) {
        errorMessage = error.localizedDescription
        storedValue = nil
        pendingOperation = nil
        expressionText = ""
        isTyping = false
        resultText = nil
        lastOperation = nil
    }

    private func appendHistory(expression: String, result: String) {
        let entry = CalculationHistoryEntry(expression: expression, result: result)
        history.insert(entry, at: 0)
        historyStore.save(history)
    }
}
