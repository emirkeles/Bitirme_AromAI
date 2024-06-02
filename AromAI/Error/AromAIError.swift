//
//  Error.swift
//  AromAI
//
//  Created by Emir Keleş on 30.04.2024.
//

import Foundation
import SwiftUI

enum AromAIError: LocalizedError {
    case custom
    case success(String?)
    
    var errorDescription: String? {
        switch self {
        case .custom:
            return "Custom error localized description"
        case .success(let string):
            return string ?? "Başarılı"
        }
    }
}

@MainActor
final class ErrorAlert: ObservableObject {

    @Published var error: Error?
    @Published var title: String?
    @Published var buttonTitle: String?
    @Published var action: (() -> Void)?
    
    func present(
        _ error: Error,
        title: String = "Error",
        buttonTitle: String = "OK",
        action: (() -> Void)? = nil
    ) {
        print(error.localizedDescription)
        self.error = error
        self.title = title
        self.buttonTitle = buttonTitle
        self.action = action
    }
}


struct UseErrorAlertViewModifier: ViewModifier {
    @StateObject private var errorAlert = ErrorAlert()
    func body(content: Content) -> some View {
        content
            .modifier(ErrorAlertViewModifier())
            .environment(\.errorAlert, errorAlert)
    }
}


struct ErrorAlertViewModifier: ViewModifier {
    @Environment(\.errorAlert) private var errorAlert
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        content
            .alert(errorAlert.title ?? "Error", isPresented: $isPresented) {
                Button(errorAlert.buttonTitle ?? "") {
                    errorAlert.action?()
                    errorAlert.error = nil
                    errorAlert.title = nil
                    errorAlert.buttonTitle = nil
                    errorAlert.action = nil
                }
            } message: {
                Text(errorAlert.error?.localizedDescription ?? "")
            }
            .onReceive(errorAlert.$error, perform: { newValue in
                if newValue != nil {
                    isPresented = true
                }
            })
    }
}
