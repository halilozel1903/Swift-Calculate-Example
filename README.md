# Swift Calculate Example

[![Swift](https://img.shields.io/badge/Swift-6.3-FA7343?logo=swift&logoColor=white)](https://www.swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-26.6-1575F9?logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![Platform](https://img.shields.io/badge/iOS-26.0%2B-000000?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![UI](https://img.shields.io/badge/UI-SwiftUI-0A84FF?logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![Tests](https://img.shields.io/badge/tests-Swift%20Testing-4BC51D)](https://developer.apple.com/documentation/testing)
[![CI](https://github.com/halilozel1903/swift-calculate-example/actions/workflows/ci.yml/badge.svg)](https://github.com/halilozel1903/swift-calculate-example/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A modern iOS calculator sample built with SwiftUI, Swift 6 language mode, and the Swift 6.3 toolchain.

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
| Xcode | 26.6 or later (stable; Xcode 27 is preview-only on GitHub runners as of Oct 2026) |
| Swift | 6 language mode on the Swift 6.3 toolchain |
| iOS deployment target | 26.0 or later |
| Devices | iPhone and iPad |

## Getting Started

Requires **macOS** with **Xcode 26.6+** (Swift 6.3 toolchain) and an **iOS 26** simulator.

```bash
git clone https://github.com/halilozel1903/swift-calculate-example.git
cd swift-calculate-example
```

### Open in Xcode

```bash
open Calculator.xcodeproj
```

1. Select the shared **Calculator** scheme.
2. Choose an **iOS 26** simulator (iPhone or iPad).
3. Press **Cmd + R** to run, or **Cmd + U** to run tests.

### Build, test, and run from the CLI

Prefer an iOS 26 simulator so the destination matches the deployment target. Resolve a UDID once, then reuse it:

```bash
# Prefer an available iPhone on an iOS 26 runtime
udid=$(xcrun simctl list devices available --json | jq -r '
  [.devices | to_entries[] | select(.key | test("iOS-26")) | .value[]
   | select(.name | test("iPhone"))] | last | .udid // empty')

# Fallback: any available iPhone simulator
if [ -z "$udid" ]; then
  udid=$(xcrun simctl list devices available --json | jq -r '
    [.devices | to_entries[] | select(.key | test("iOS")) | .value[]
     | select(.name | test("iPhone"))] | last | .udid // empty')
fi

echo "Using simulator: ${udid}"
```

You can also pass a named destination instead of a UDID:

```bash
# Examples — adjust the device name to one listed by `xcrun simctl list devices available`
-destination 'platform=iOS Simulator,name=iPhone 17,OS=26.0'
-destination "id=${udid}"
```

**Build**

```bash
xcodebuild build \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination "id=${udid}" \
  CODE_SIGNING_ALLOWED=NO
```

**Test** (Swift Testing suites under `CalculatorTests`)

```bash
xcodebuild test \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination "id=${udid}" \
  CODE_SIGNING_ALLOWED=NO
```

CI uses the same scheme with `build-for-testing` / `test-without-building` on `macos-26` + Xcode 26.6.

**Run** (build, install, and launch on the booted simulator)

```bash
xcrun simctl boot "${udid}" 2>/dev/null || true
open -a Simulator

xcodebuild build \
  -project Calculator.xcodeproj \
  -scheme Calculator \
  -destination "id=${udid}" \
  -derivedDataPath build \
  CODE_SIGNING_ALLOWED=NO

app=$(find build/Build/Products -name 'Calculator.app' | head -n 1)
xcrun simctl install booted "$app"
xcrun simctl launch booted com.ozel.halil.Calculator
```

### Lint

SwiftLint is enforced in CI (`swiftlint lint --strict`). Install locally if needed (`brew install swiftlint`), then:

```bash
swiftlint lint --strict
```

Optional formatting config lives in `.swift-format` (SwiftFormat / `swift format` when you use those tools).
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
├── docs/screenshots                        # UI mocks + capture notes
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
- The project builds with the Swift 6 language mode, Swift 6.3 toolchain defaults
  (`SWIFT_APPROACHABLE_CONCURRENCY`, `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`), and
  complete strict concurrency checking. Domain models stay `nonisolated` so engine tests
  can run off the main actor.

## Screenshots

Layout mocks that match the SwiftUI UI (standard keypad, landscape scientific keys, iPad history).
These are SVG illustrations — Linux CI hosts cannot capture the iOS Simulator GUI. Replace them with
real PNGs when you have a Mac; see [docs/screenshots/README.md](docs/screenshots/README.md).

| iPhone portrait | iPhone landscape | iPad |
| --- | --- | --- |
| ![iPhone portrait](docs/screenshots/iphone-portrait.svg) | ![iPhone landscape](docs/screenshots/iphone-landscape.svg) | ![iPad](docs/screenshots/ipad.svg) |

**Expected PNG paths** (optional, after a simulator capture):

- `docs/screenshots/iphone-portrait.png`
- `docs/screenshots/iphone-landscape.png`
- `docs/screenshots/ipad.png`

```bash
xcrun simctl io booted screenshot docs/screenshots/iphone-portrait.png
```

## Roadmap

- Memory keys (`MC`, `MR`, `M+`, `M−`)
- Degree / radian mode for trigonometric functions
- Widget or App Intent for quick calculations
- Replace SVG mocks with checked-in simulator PNGs

## Contributing

Issues and pull requests are welcome.

1. Fork the repository and create a branch: `git checkout -b feature/my-change`.
2. Keep commits small and use conventional subjects (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`).
3. Run `swiftlint lint --strict` and `xcodebuild test` (or `Cmd + U`) before pushing.
4. Open a pull request describing the change and how you verified it.

## License

Released under the MIT License. See [LICENSE](LICENSE) for details.
