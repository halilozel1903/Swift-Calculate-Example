//
//  CalculationHistoryStore.swift
//  Calculator
//

import Foundation

/// Persists calculation history in `UserDefaults`.
///
/// Not marked `Sendable` because `UserDefaults` is not Sendable; call sites
/// keep the store on the main actor via ``CalculatorViewModel``.
nonisolated final class CalculationHistoryStore: @unchecked Sendable {
    private let defaults: UserDefaults
    private let key: String
    private let maximumEntries: Int

    init(
        defaults: UserDefaults = .standard,
        key: String = "calculator.history",
        maximumEntries: Int = 50
    ) {
        self.defaults = defaults
        self.key = key
        self.maximumEntries = maximumEntries
    }

    func load() -> [CalculationHistoryEntry] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([CalculationHistoryEntry].self, from: data)) ?? []
    }

    func save(_ entries: [CalculationHistoryEntry]) {
        let trimmed = Array(entries.prefix(maximumEntries))
        guard let data = try? JSONEncoder().encode(trimmed) else { return }
        defaults.set(data, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
