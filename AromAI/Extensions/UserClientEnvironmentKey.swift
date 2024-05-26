//
//  UserClientEnvironmentKey.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import Foundation
import SwiftUI

private struct UserClientEnvironmentKey: EnvironmentKey {
    @MainActor
    static let defaultValue = UserClient()
}

extension EnvironmentValues {
    var userClient: UserClient {
        get { self[UserClientEnvironmentKey.self] }
        set { self[UserClientEnvironmentKey.self] = newValue }
    }
}

