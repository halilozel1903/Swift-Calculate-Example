//
//  CalculationHistoryEntry.swift
//  Calculator
//

import Foundation

/// One completed calculation kept for the history list.
nonisolated struct CalculationHistoryEntry: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let expression: String
    let result: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        expression: String,
        result: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.expression = expression
        self.result = result
        self.createdAt = createdAt
    }
}
