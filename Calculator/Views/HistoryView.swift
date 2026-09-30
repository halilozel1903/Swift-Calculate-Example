//
//  HistoryView.swift
//  Calculator
//

import SwiftUI

/// Lists persisted calculation history.
struct HistoryView: View {
    let entries: [CalculationHistoryEntry]
    let onClear: () -> Void
    let onSelect: (CalculationHistoryEntry) -> Void

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView(
                        "No History",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Completed calculations will show up here.")
                    )
                } else {
                    List {
                        ForEach(entries) { entry in
                            Button {
                                onSelect(entry)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.expression)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text(entry.result)
                                        .font(.title3.monospacedDigit().weight(.semibold))
                                        .foregroundStyle(.primary)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(entry.expression) equals \(entry.result)")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", role: .destructive, action: onClear)
                        .disabled(entries.isEmpty)
                }
            }
        }
    }
}

#Preview {
    HistoryView(
        entries: [
            CalculationHistoryEntry(expression: "12 × 12", result: "144")
        ],
        onClear: {},
        onSelect: { _ in }
    )
}
