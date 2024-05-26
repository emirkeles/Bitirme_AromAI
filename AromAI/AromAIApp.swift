//
//  AromAIApp.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI
import SwiftData


@main
struct AromAIApp: App {
    @AppStorage("onboardCompleted") var onboardCompleted: Bool = false
    @AppStorage("registrationDetailsCompleted") var registrationDetailsCompleted: Bool = false
    @AppStorage("loggedIn") var loggedIn: Bool = false
    init() {
        UISegmentedControl.appearance().backgroundColor = .lightGray.withAlphaComponent(0.2)
        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 234/255, green: 109/255, blue: 109/255, alpha: 1)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    @State var userClient = UserClient()
    var body: some Scene {
        WindowGroup {
            if !onboardCompleted {
                OnboardingView(slides: slideData)
            }else {
                if userClient.isValidated || loggedIn {
                    if !registrationDetailsCompleted {
                        RegistrationFlowView()
                            .environment(\.userClient, userClient)
                            .useErrorAlert()
                    } else {
                        ContentView()
                            .environment(\.userClient, userClient)
                            .useErrorAlert()
                    }
                }
                else {
                    LoginView()
                        .environment(\.userClient, userClient)
                        .useErrorAlert()
                }
            }
        }
    }
}

