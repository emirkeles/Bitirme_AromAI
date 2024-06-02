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
    @AppStorage("language") var language: String = "tr-TR"
    
    @State var userClient = UserClient()
    
    init() {
        configureAppearance()
        getInfo()
        getCuisines()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentViewSwitcher()
                .environment(\.userClient, userClient)
                .useErrorAlert()
                .environment(\.locale, Locale(identifier: language))
        }
    }
}

extension AromAIApp {
    func getInfo() {
        Task {
            try await userClient.getPersonalInfo()
        }
    }
    
    func getCuisines() {
        Task {
            try await userClient.getCuisines(searchText: nil, page: nil, pageSize: nil)
        }
    }
    
}
