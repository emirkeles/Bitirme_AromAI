//
//  View+Extension.swift
//  AromAI
//
//  Created by Emir Keleş on 30.04.2024.
//

import Foundation
import SwiftUI

extension View {
    func useErrorAlert() -> some View {
        modifier(UseErrorAlertViewModifier())
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
