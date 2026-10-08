# Screenshots

Checked-in assets are **SVG layout mocks** that mirror the SwiftUI calculator (standard keypad, landscape scientific keys, iPad history panel). They are intentional illustrations — not binary PNGs fabricated from a simulator.

| File | Intended capture |
| --- | --- |
| `iphone-portrait.svg` | iPhone portrait, standard keypad |
| `iphone-landscape.svg` | iPhone landscape with scientific keys |
| `ipad.svg` | iPad / regular width with history |

## Replace with real simulator captures

On a Mac with Xcode 26.6+ and an iOS 26 simulator:

```bash
# Boot a simulator (example name — pick any available iPhone / iPad)
xcrun simctl boot "iPhone 17" || true
open -a Simulator

# Build & run the app, then capture the window
xcrun simctl io booted screenshot docs/screenshots/iphone-portrait.png

# Rotate to landscape in Simulator, then:
xcrun simctl io booted screenshot docs/screenshots/iphone-landscape.png

# Switch destination to an iPad simulator for the wide layout:
xcrun simctl io booted screenshot docs/screenshots/ipad.png
```

After adding PNGs, update the root [README.md](../../README.md) Screenshots section to prefer the PNGs (keep the SVGs as fallbacks or remove them). Do not commit empty or placeholder binary PNG files.
