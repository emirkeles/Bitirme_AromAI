//
//  ErrorAlertEnvironmentKey.swift
//  AromAI
//
//  Created by Emir Keleş on 30.04.2024.
//

import Foundation
import SwiftUI

struct ErrorAlertEnvironmentKey: EnvironmentKey {
    @MainActor
    static let defaultValue = ErrorAlert()
}

extension EnvironmentValues {
    var errorAlert: ErrorAlert {
        get {
            return self[ErrorAlertEnvironmentKey.self]
        }
        set {
            self[ErrorAlertEnvironmentKey.self] = newValue
        }
    }
}
