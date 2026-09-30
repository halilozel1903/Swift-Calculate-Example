//
//  CalculatorViewModelTests.swift
//  CalculatorTests
//

import Foundation
import Testing

@testable import Calculator

@MainActor
@Suite("Calculator view model")
struct CalculatorViewModelTests {
    private func makeViewModel(
        suiteName: String = UUID().uuidString
    ) -> CalculatorViewModel {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            Issue.record("Unable to create UserDefaults suite \(suiteName)")
            return CalculatorViewModel(
                engine: CalculatorEngine(locale: Locale(identifier: "en_US")),
                historyStore: CalculationHistoryStore(key: "tests.history.\(suiteName)")
            )
        }
        defaults.removePersistentDomain(forName: suiteName)
        return CalculatorViewModel(
            engine: CalculatorEngine(locale: Locale(identifier: "en_US")),
            historyStore: CalculationHistoryStore(defaults: defaults, key: "tests.history")
        )
    }

    @Test("Publishes a formatted result")
    func successfulCalculation() {
        let viewModel = makeViewModel()
        viewModel.firstOperandText = "12"
        viewModel.secondOperandText = "4"

        viewModel.calculate(.division)

        #expect(viewModel.resultText == "3")
        #expect(viewModel.lastOperation == .division)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.history.count == 1)
    }

    @Test("Publishes an error message and clears the stale result")
    func failedCalculation() {
        let viewModel = makeViewModel()
        viewModel.firstOperandText = "12"
        viewModel.secondOperandText = "4"
        viewModel.calculate(.addition)

        viewModel.secondOperandText = "0"
        viewModel.calculate(.division)

        #expect(viewModel.resultText == nil)
        #expect(viewModel.lastOperation == nil)
        #expect(viewModel.errorMessage == CalculatorError.divisionByZero.localizedDescription)
    }

    @Test("Clear resets every field")
    func clear() {
        let viewModel = makeViewModel()
        viewModel.firstOperandText = "1"
        viewModel.secondOperandText = "2"
        viewModel.calculate(.addition)

        viewModel.clear()

        #expect(viewModel.firstOperandText.isEmpty)
        #expect(viewModel.secondOperandText.isEmpty)
        #expect(viewModel.resultText == nil)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.displayText == "0")
        #expect(viewModel.isEmpty)
    }

    @Test("Keypad evaluates a basic expression")
    func keypadAddition() {
        let viewModel = makeViewModel()
        viewModel.input(.digit(1))
        viewModel.input(.digit(2))
        viewModel.input(.operation(.addition))
        viewModel.input(.digit(3))
        viewModel.input(.equals)

        #expect(viewModel.displayText == "15")
        #expect(viewModel.history.first?.expression == "12 + 3")
        #expect(viewModel.history.first?.result == "15")
    }

    @Test("Keypad chains binary operations")
    func keypadChaining() {
        let viewModel = makeViewModel()
        viewModel.input(.digit(1))
        viewModel.input(.operation(.addition))
        viewModel.input(.digit(2))
        viewModel.input(.operation(.addition))
        viewModel.input(.digit(3))
        viewModel.input(.equals)

        #expect(viewModel.displayText == "6")
    }

    @Test("Percent and sign change update the display")
    func percentAndNegate() {
        let viewModel = makeViewModel()
        viewModel.input(.digit(5))
        viewModel.input(.digit(0))
        viewModel.input(.operation(.percent))
        #expect(viewModel.displayText == "0.5")

        viewModel.input(.operation(.negate))
        #expect(viewModel.displayText == "-0.5")
    }

    @Test("Scientific square root works from the keypad")
    func keypadSquareRoot() {
        let viewModel = makeViewModel()
        viewModel.input(.digit(9))
        viewModel.input(.operation(.squareRoot))
        #expect(viewModel.displayText == "3")
        #expect(viewModel.history.first?.result == "3")
    }

    @Test("All clear resets keypad state")
    func allClear() {
        let viewModel = makeViewModel()
        viewModel.input(.digit(8))
        viewModel.input(.operation(.multiplication))
        viewModel.input(.allClear)

        #expect(viewModel.displayText == "0")
        #expect(viewModel.expressionText.isEmpty)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("History persists and can be restored")
    func historyPersistence() {
        let suite = UUID().uuidString
        let first = makeViewModel(suiteName: suite)
        first.input(.digit(2))
        first.input(.operation(.multiplication))
        first.input(.digit(5))
        first.input(.equals)

        let second = makeViewModel(suiteName: suite)
        #expect(second.history.count == 1)
        #expect(second.history.first?.result == "10")

        if let entry = second.history.first {
            second.restore(entry)
            #expect(second.displayText == "10")
        }
    }

    @Test("Clear history empties the store")
    func clearHistory() {
        let viewModel = makeViewModel()
        viewModel.input(.digit(1))
        viewModel.input(.operation(.addition))
        viewModel.input(.digit(1))
        viewModel.input(.equals)
        viewModel.clearHistory()
        #expect(viewModel.history.isEmpty)
    }
}
