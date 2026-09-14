# Swift Calculate Example 🧮

[![Swift](https://img.shields.io/badge/Swift-6.0-FA7343?logo=swift&logoColor=white)](https://www.swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-26-1575F9?logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/iOS-18.0%2B-000000?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![UI](https://img.shields.io/badge/UI-SwiftUI-0A84FF?logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![Tests](https://img.shields.io/badge/tests-Swift%20Testing-4BC51D)](https://developer.apple.com/documentation/testing)
[![CI](https://github.com/halilozel1903/swift-calculate-example/actions/workflows/ci.yml/badge.svg)](https://github.com/halilozel1903/swift-calculate-example/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A tiny iOS calculator sample: type two numbers, pick an operation, read the result.

The app originally shipped in 2017 as a UIKit storyboard project with integer-only maths. It has since
been rebuilt in SwiftUI on the Swift 6 language mode, with the arithmetic moved into a dependency-free,
unit-tested engine.

## Features

- ➕ ➖ ✖️ ➗ Addition, subtraction, multiplication and division of two numbers.
- 🔢 Decimal and negative input, with both `,` and `.` accepted as the decimal separator.
- 🛡️ Friendly errors instead of crashes for empty fields, non-numeric text, division by zero and overflow.
- 🧾 Locale-aware result formatting that drops a trailing `.0` and caps at eight fraction digits.
- ⌨️ Keyboard-aware layout with focus handling, a `Next`/`Done` submit flow and a `Clear` action.
- ♿ VoiceOver labels on the operation buttons, Dynamic Type friendly text and selectable results.
- 🧪 Unit tests for the calculation engine and the view model, plus CI on every pull request.

## Requirements

| Tool | Version |
| --- | --- |
| Xcode | 26.0 or later |
| Swift | 6.0 language mode (Swift 6.2 toolchain) |
| iOS deployment target | 18.0 or later |
| Devices | iPhone and iPad |

## Getting Started

```bash
git clone https://github.com/halilozel1903/swift-calculate-example.git
cd swift-calculate-example
open Calculator.xcodeproj
```

Select the `Calculator` scheme and an iOS simulator, then press `Cmd + R` to run or `Cmd + U` to test.

From the command line:

```bash
# Build
xcodebuild build \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Test
xcodebuild test \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Project Structure

```text
swift-calculate-example
├── Calculator
│   ├── CalculatorApp.swift            # SwiftUI app entry point
│   ├── Models
│   │   ├── CalculatorEngine.swift     # Parsing, evaluation and formatting
│   │   ├── CalculatorError.swift      # Typed, localized failures
│   │   └── CalculatorOperation.swift  # The four supported operations
│   ├── ViewModels
│   │   └── CalculatorViewModel.swift  # @Observable screen state
│   ├── Views
│   │   ├── CalculatorView.swift       # Main screen
│   │   ├── OperandField.swift         # Numeric input field
│   │   └── ResultView.swift           # Result / error card
│   └── Assets.xcassets                # App icon and accent color
├── CalculatorTests                    # Swift Testing suites
├── Calculator.xcodeproj               # Xcode project (shared scheme)
├── .github/workflows/ci.yml           # Build, test and lint on CI
├── .swiftlint.yml                     # SwiftLint rules
└── .swift-format                      # swift-format rules
```

### Architecture notes

- `CalculatorEngine` is a `Sendable` value type with no UI dependency, so it can be reused and tested in
  isolation. It reports failures through typed `throws(CalculatorError)`.
- `CalculatorViewModel` is `@MainActor` and `@Observable`; the views observe it through `@State`.
- The project builds with the Swift 6 language mode and complete strict concurrency checking, and the app
  uses the SwiftUI lifecycle, so there is no `AppDelegate`, storyboard or hand-written `Info.plist`.

## Contributing

Issues and pull requests are welcome.

1. Fork the repository and create a branch: `git checkout -b feature/my-change`.
2. Keep commits small and use conventional subjects (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`).
3. Run `swiftlint lint --strict` and `Cmd + U` before pushing.
4. Open a pull request describing the change and how you verified it.

## License

Released under the MIT License. See [LICENSE](LICENSE) for details.
