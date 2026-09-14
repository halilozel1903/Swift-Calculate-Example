//
//  CalculatorView.swift
//  Calculator
//

import SwiftUI

/// Two operands, four operations, one result.
struct CalculatorView: View {
    @State private var viewModel = CalculatorViewModel()
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case first
        case second
    }

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
                        focusedField = nil
                    }
                    .disabled(viewModel.isEmpty)
                }

                ToolbarItem(placement: .keyboard) {
                    Button("Done") { focusedField = nil }
                }
            }
        }
    }

    private var operandFields: some View {
        VStack(spacing: 12) {
            OperandField(
                title: "First number",
                text: $viewModel.firstOperandText
            )
            .focused($focusedField, equals: .first)
            .submitLabel(.next)
            .onSubmit { focusedField = .second }

            OperandField(
                title: "Second number",
                text: $viewModel.secondOperandText
            )
            .focused($focusedField, equals: .second)
            .submitLabel(.done)
            .onSubmit { focusedField = nil }
        }
    }

    private var operationGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(spacing: 12), count: 2),
            spacing: 12
        ) {
            ForEach(CalculatorOperation.allCases) { operation in
                Button {
                    focusedField = nil
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
