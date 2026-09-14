//
//  CalculatorEngineTests.swift
//  CalculatorTests
//

import Foundation
import Testing

@testable import Calculator

@Suite("Calculator engine")
struct CalculatorEngineTests {
    private let engine = CalculatorEngine(locale: Locale(identifier: "en_US"))

    struct OperationCase: Sendable {
        let operation: CalculatorOperation
        let lhs: Double
        let rhs: Double
        let expected: Double
    }

    @Test("Applies each operation", arguments: [
        OperationCase(operation: .addition, lhs: 7, rhs: 3, expected: 10),
        OperationCase(operation: .subtraction, lhs: 7, rhs: 3, expected: 4),
        OperationCase(operation: .multiplication, lhs: 7, rhs: 3, expected: 21),
        OperationCase(operation: .division, lhs: 7, rhs: 2, expected: 3.5)
    ])
    func operations(testCase: OperationCase) throws {
        let value = try engine.result(
            of: testCase.operation,
            lhs: testCase.lhs,
            rhs: testCase.rhs
        )
        #expect(value == testCase.expected)
    }

    @Test("Division keeps the fractional part")
    func integerDivisionIsNotTruncated() throws {
        let value = try engine.evaluate(
            .division,
            firstOperandText: "7",
            secondOperandText: "2"
        )
        #expect(value == 3.5)
    }

    @Test("Division by zero fails instead of trapping", arguments: ["0", "0.0", "-0"])
    func divisionByZero(divisor: String) {
        #expect(throws: CalculatorError.divisionByZero) {
            try engine.evaluate(
                .division,
                firstOperandText: "1",
                secondOperandText: divisor
            )
        }
    }

    @Test("Reports which operand is invalid")
    func invalidOperands() {
        #expect(throws: CalculatorError.invalidOperand(.first)) {
            try engine.evaluate(.addition, firstOperandText: "", secondOperandText: "2")
        }
        #expect(throws: CalculatorError.invalidOperand(.second)) {
            try engine.evaluate(.addition, firstOperandText: "2", secondOperandText: "abc")
        }
        #expect(throws: CalculatorError.invalidOperand(.first)) {
            try engine.evaluate(.addition, firstOperandText: "   ", secondOperandText: "2")
        }
    }

    @Test("Rejects non-finite operands")
    func nonFiniteOperands() {
        #expect(throws: CalculatorError.invalidOperand(.first)) {
            try engine.evaluate(.addition, firstOperandText: "inf", secondOperandText: "1")
        }
        #expect(throws: CalculatorError.invalidOperand(.second)) {
            try engine.evaluate(.addition, firstOperandText: "1", secondOperandText: "nan")
        }
    }

    @Test("Overflowing results are rejected")
    func overflow() {
        #expect(throws: CalculatorError.resultUnrepresentable) {
            try engine.result(of: .multiplication, lhs: .greatestFiniteMagnitude, rhs: 10)
        }
    }

    @Test("Accepts decimals and negative numbers")
    func decimalsAndNegatives() throws {
        let value = try engine.evaluate(
            .addition,
            firstOperandText: " -1.5 ",
            secondOperandText: "2.25"
        )
        #expect(value == 0.75)
    }

    @Test("Reads comma and dot as decimal separators")
    func decimalSeparators() throws {
        let turkish = CalculatorEngine(locale: Locale(identifier: "tr_TR"))
        #expect(try turkish.operand(from: "1,5", at: .first) == 1.5)
        #expect(try turkish.operand(from: "1.5", at: .first) == 1.5)
        #expect(try engine.operand(from: "1,5", at: .first) == 1.5)
        #expect(try engine.operand(from: "1.5", at: .first) == 1.5)
    }

    @Test("Reads a grouped number using the locale")
    func groupedNumber() throws {
        #expect(try engine.operand(from: "1,234.5", at: .first) == 1234.5)
        let turkish = CalculatorEngine(locale: Locale(identifier: "tr_TR"))
        #expect(try turkish.operand(from: "1.234,5", at: .first) == 1234.5)
    }

    @Test("Accepts a minus sign typed as U+2212")
    func unicodeMinusSign() throws {
        #expect(try engine.operand(from: "\u{2212}3", at: .first) == -3)
    }

    @Test("Formats whole results without a decimal separator")
    func formatting() {
        #expect(engine.formatted(4) == "4")
        #expect(engine.formatted(3.5) == "3.5")
        #expect(engine.formatted(1.0 / 3.0) == "0.33333333")
    }
}
