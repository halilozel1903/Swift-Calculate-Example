//
//  CalculatorView.swift
//  Calculator
//

import SwiftUI

/// Two operands, four operations, one result.
struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @FocusState private var focus: OperandFieldID?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    operandFields
                    operationGrid
                    ResultView(
                        resultText: viewModel.resultText,
                        errorMessage: viewModel.errorMessage,
                        operation: viewModel.lastOperation
                    )
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Calculator")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", systemImage: "trash") {
                        viewModel.clear()
                        focus = nil
                    }
                    .disabled(viewModel.isEmpty)
                }

                ToolbarItem(placement: .keyboard) {
                    Button("Done") { focus = nil }
                }
            }
        }
    }

    private var operandFields: some View {
        VStack(spacing: 12) {
            OperandField(
                title: "First number",
                id: .first,
                text: $viewModel.firstOperandText,
                focus: $focus
            )
            .submitLabel(.next)
            .onSubmit { focus = .second }

            OperandField(
                title: "Second number",
                id: .second,
                text: $viewModel.secondOperandText,
                focus: $focus
            )
            .submitLabel(.done)
            .onSubmit { focus = nil }
        }
    }

    private var operationGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(spacing: 12), count: 2),
            spacing: 12
        ) {
            ForEach(CalculatorOperation.allCases) { operation in
                Button {
                    focus = nil
                    viewModel.calculate(operation)
                } label: {
                    Text(operation.symbol)
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity, minHeight: 56)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel(operation.accessibilityName)
            }
        }
    }
}

#Preview {
    CalculatorView()
}
