//
//  CalculatorView.swift
//  Calculator
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Full calculator with keypad, history, haptics and adaptive layout.
struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showsHistory = false
    @State private var copiedBanner = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let landscape = geometry.size.width > geometry.size.height
                let showsScientific = shouldShowScientific(landscape: landscape)

                Group {
                    if landscape && horizontalSizeClass == .regular {
                        wideLayout(showsScientific: showsScientific)
                    } else if landscape {
                        landscapePhoneLayout(showsScientific: showsScientific)
                    } else {
                        portraitLayout(showsScientific: showsScientific)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("History", systemImage: "clock.arrow.circlepath") {
                        showsHistory = true
                    }
                    .accessibilityLabel("Calculation history")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Copy", systemImage: "doc.on.doc") {
                        copyResult()
                    }
                    .accessibilityLabel("Copy result")
                }
            }
            .sheet(isPresented: $showsHistory) {
                HistoryView(
                    entries: viewModel.history,
                    onClear: viewModel.clearHistory,
                    onSelect: { entry in
                        viewModel.restore(entry)
                        showsHistory = false
                    }
                )
                .presentationDetents([.medium, .large])
            }
            .overlay(alignment: .top) {
                if copiedBanner {
                    Text("Copied")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.thinMaterial, in: .capsule)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .accessibilityLabel("Result copied")
                }
            }
            .animation(.snappy, value: copiedBanner)
        }
    }

    private func portraitLayout(showsScientific: Bool) -> some View {
        VStack(spacing: 16) {
            display
            KeypadView(
                clearTitle: viewModel.clearKeyTitle,
                showsScientific: showsScientific,
                onKey: handle
            )
        }
    }

    private func landscapePhoneLayout(showsScientific: Bool) -> some View {
        HStack(alignment: .top, spacing: 16) {
            display
                .frame(maxWidth: .infinity)
            KeypadView(
                clearTitle: viewModel.clearKeyTitle,
                showsScientific: showsScientific,
                onKey: handle
            )
            .frame(maxWidth: .infinity)
        }
    }

    private func wideLayout(showsScientific: Bool) -> some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(spacing: 16) {
                display
                if !viewModel.history.isEmpty {
                    recentHistory
                }
            }
            .frame(maxWidth: 420)

            KeypadView(
                clearTitle: viewModel.clearKeyTitle,
                showsScientific: showsScientific,
                onKey: handle
            )
            .frame(maxWidth: 560)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var display: some View {
        DisplayView(
            expressionText: viewModel.expressionText,
            displayText: viewModel.displayText,
            errorMessage: viewModel.errorMessage,
            onCopy: copyResult
        )
        .frame(minHeight: 120)
    }

    private var recentHistory: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent")
                .font(.headline)
            ForEach(viewModel.history.prefix(5)) { entry in
                Button {
                    viewModel.restore(entry)
                    HapticFeedback.keyTap()
                } label: {
                    HStack {
                        Text(entry.expression)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(entry.result)
                            .fontWeight(.semibold)
                            .monospacedDigit()
                    }
                    .font(.subheadline)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Reuse \(entry.expression) equals \(entry.result)")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }

    private func shouldShowScientific(landscape: Bool) -> Bool {
        horizontalSizeClass == .regular || landscape || verticalSizeClass == .compact
    }

    private func handle(_ key: CalculatorKey) {
        let hadError = viewModel.errorMessage != nil
        viewModel.input(key)
        if viewModel.errorMessage != nil {
            HapticFeedback.error()
        } else if case .equals = key, !hadError {
            HapticFeedback.success()
        } else {
            HapticFeedback.keyTap()
        }
    }

    private func copyResult() {
        _ = viewModel.copyDisplayToPasteboard()
        #if canImport(UIKit)
        UIPasteboard.general.string = viewModel.displayText
        #endif
        HapticFeedback.success()
        copiedBanner = true
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.2))
            copiedBanner = false
        }
    }
}

#Preview {
    CalculatorView()
}
