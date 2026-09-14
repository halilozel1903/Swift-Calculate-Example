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
    private func makeViewModel() -> CalculatorViewModel {
        CalculatorViewModel(engine: CalculatorEngine(locale: Locale(identifier: "en_US")))
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
        #expect(viewModel.isEmpty)
    }
}
