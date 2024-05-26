//
//  RegistrationFlowView.swift
//  AromAI
//
//  Created by Emir Keleş on 28.03.2024.
//

import SwiftUI
enum RegistrationStep {
    case diet
    case allergy
    case likedCountry
}
struct RegistrationFlowView: View {
    @State private var navigationPath = [RegistrationStep]()
    var body: some View {
        NavigationStack(path: $navigationPath) {
            AllergyView(navigationPath: $navigationPath)
                .navigationDestination(for: RegistrationStep.self) { step in
                    switch step {
                    case .diet:
                        DietView(navigationPath: $navigationPath)
                    case .allergy:
                        AllergyView(navigationPath: $navigationPath)
                    case .likedCountry:
                        LikedKitchenView()
                    }
                }
        }
    }
}
