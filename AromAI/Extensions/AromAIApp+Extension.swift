//
//  AromAIApp+Extension.swift
//  AromAI
//
//  Created by Emir Keleş on 14.05.2024.
//

import Foundation
import SwiftUI

// MARK: - ContentViewSwitcher
extension AromAIApp {
    @ViewBuilder
    func ContentViewSwitcher() -> some View {
        if !onboardCompleted {
            OnboardingView(slides: slideData)
        } else if userClient.isValidated || loggedIn {
            if !registrationDetailsCompleted {
                RegistrationFlowView()
            } else {
                ContentView()
            }
        } else {
            LoginView()
        }
    }
}

// MARK: - Private Functions
extension AromAIApp {
    func configureAppearance() {
        let appearance = UISegmentedControl.appearance()
        appearance.backgroundColor = .lightGray.withAlphaComponent(0.2)
        appearance.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        appearance.selectedSegmentTintColor = UIColor(red: 234/255, green: 109/255, blue: 109/255, alpha: 1)
        appearance.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}


