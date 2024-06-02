//
//  ErrorAlertEnvironmentKey.swift
//  AromAI
//
//  Created by Emir Keleş on 30.04.2024.
//

import Foundation
import SwiftUI

private struct ErrorAlertEnvironmentKey: EnvironmentKey {
    @MainActor
    static let defaultValue: ErrorAlert = ErrorAlert()
}

extension EnvironmentValues {
    var errorAlert: ErrorAlert {
        get { self[ErrorAlertEnvironmentKey.self] }
        set { self[ErrorAlertEnvironmentKey.self] = newValue }
    }
}
