//
//  HapticFeedback.swift
//  Calculator
//

#if canImport(UIKit)
import UIKit
#endif

/// Light haptic taps for keypad presses.
@MainActor
enum HapticFeedback {
    static func keyTap() {
        #if canImport(UIKit)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    static func success() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    static func error() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }
}
