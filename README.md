# Swift Calculate Example

[![Swift](https://img.shields.io/badge/Swift-6.0-FA7343?logo=swift&logoColor=white)](https://www.swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-26-1575F9?logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/iOS-18.0%2B-000000?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![UI](https://img.shields.io/badge/UI-SwiftUI-0A84FF?logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![Tests](https://img.shields.io/badge/tests-Swift%20Testing-4BC51D)](https://developer.apple.com/documentation/testing)
[![CI](https://github.com/halilozel1903/swift-calculate-example/actions/workflows/ci.yml/badge.svg)](https://github.com/halilozel1903/swift-calculate-example/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A modern iOS calculator sample built with SwiftUI and Swift 6.

What started as a 2017 UIKit storyboard demo (integer-only maths, two text fields) is now a real
calculator: full keypad, scientific operations, persisted history, haptics, copy-to-clipboard, and
layouts that adapt to iPhone, iPad and landscape.

## Features

- Full on-screen keypad with digits, decimal separator, clear / all-clear, equals and four-function math
- Percent (`%`) and sign change (`+/−`)
- Scientific operations: √, x², 1/x, xⁿ, sin, cos, tan, ln, log, eˣ, 10ˣ, plus π and e constants
- Calculation history persisted with `UserDefaults`, browsable in a sheet and quick-reuse on iPad
- Copy result from the toolbar, context menu or double-tap
- Light haptic feedback on key presses, success and errors
- Dynamic Type aware labels and VoiceOver names on every key
- Adaptive layout for portrait phone, landscape phone and regular-width iPad
- Locale-aware parsing and formatting (`,` or `.` as decimal separators)
- Friendly errors for division by zero, invalid domain values and overflow
- Unit tests with Swift Testing and CI on every pull request

## Requirements

| Tool | Version |
| --- | --- |
| Xcode | 26.0 or later |
| Swift | 6.0 language mode |
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
# Resolve a simulator UDID, then build / test
udid=$(xcrun simctl list devices available --json | jq -r '
  [.devices | to_entries[] | select(.key | test("iOS")) | .value[]
   | select(.name | test("iPhone"))] | last | .udid')

xcodebuild build \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination "id=${udid}" \
  CODE_SIGNING_ALLOWED=NO

xcodebuild test \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination "id=${udid}" \
  CODE_SIGNING_ALLOWED=NO

swiftlint lint --strict
```

## Project Structure

```text
swift-calculate-example
├── Calculator
│   ├── CalculatorApp.swift                 # SwiftUI app entry point
│   ├── Models
│   │   ├── CalculatorEngine.swift          # Parsing, evaluation and formatting
│   │   ├── CalculatorError.swift           # Typed, localized failures
│   │   ├── CalculatorOperation.swift       # Binary and scientific operations
│   │   ├── CalculatorKey.swift             # Keypad button model
│   │   ├── CalculationHistoryEntry.swift   # One history row
│   │   └── CalculationHistoryStore.swift   # UserDefaults persistence
│   ├── ViewModels
│   │   └── CalculatorViewModel.swift       # Keypad state machine + history
│   ├── Views
│   │   ├── CalculatorView.swift            # Adaptive main screen
│   │   ├── DisplayView.swift               # Expression / result / copy
│   │   ├── KeypadView.swift                # Standard + scientific layout
│   │   ├── KeyButton.swift                 # Styled key control
│   │   └── HistoryView.swift               # History sheet
│   ├── Utilities
│   │   └── HapticFeedback.swift            # UIKit haptic helpers
│   └── Assets.xcassets                     # App icon and accent color
├── CalculatorTests                         # Swift Testing suites
├── Calculator.xcodeproj                    # Shared Calculator scheme
├── .github/workflows/ci.yml                # Build, test and lint
├── .swiftlint.yml
└── .swift-format
```

### Architecture notes

- `CalculatorEngine` is a `Sendable` value type with no UI dependency. It reports failures through typed
  `throws(CalculatorError)`.
- `CalculatorViewModel` is `@MainActor` and `@Observable`. It owns the keypad state machine (display,
  pending binary operation, typing flag) and writes history through `CalculationHistoryStore`.
- Layout chooses portrait, compact landscape or regular-width iPad arrangements from size classes and
  geometry. Scientific keys appear in landscape and on regular-width devices.
- The project builds with the Swift 6 language mode and complete strict concurrency checking.

## Screenshots

Screenshot assets are not checked into the repository yet. After running the app on a simulator or
device, drop images under `docs/screenshots/` (for example `iphone-portrait.png`,
`iphone-landscape.png`, `ipad.png`) and link them here.

## Roadmap

- Memory keys (`MC`, `MR`, `M+`, `M−`)
- Degree / radian mode for trigonometric functions
- Widget or App Intent for quick calculations
- Checked-in simulator screenshots for the README

## Contributing

Issues and pull requests are welcome.

1. Fork the repository and create a branch: `git checkout -b feature/my-change`.
2. Keep commits small and use conventional subjects (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`).
3. Run `swiftlint lint --strict` and `Cmd + U` before pushing.
4. Open a pull request describing the change and how you verified it.

## License

Released under the MIT License. See [LICENSE](LICENSE) for details.
