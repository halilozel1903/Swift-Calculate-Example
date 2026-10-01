//
//  CalculationHistoryStoreTests.swift
//  CalculatorTests
//

import Foundation
import Testing

@testable import Calculator

@Suite("Calculation history store")
struct CalculationHistoryStoreTests {
    @Test("Saves and loads entries")
    func roundTrip() throws {
        let suite = UUID().uuidString
        let defaults = try #require(UserDefaults(suiteName: suite))
        defaults.removePersistentDomain(forName: suite)
        let store = CalculationHistoryStore(defaults: defaults, key: "history", maximumEntries: 2)

        let entries = [
            CalculationHistoryEntry(expression: "1 + 1", result: "2"),
            CalculationHistoryEntry(expression: "2 + 2", result: "4"),
            CalculationHistoryEntry(expression: "3 + 3", result: "6")
        ]
        store.save(entries)

        let loaded = store.load()
        #expect(loaded.count == 2)
        #expect(loaded.map(\.result) == ["2", "4"])

        store.clear()
        #expect(store.load().isEmpty)
    }
}
