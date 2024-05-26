//
//  AppScreen.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case recipes
    case ai
    case myRecipes
    case account
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .recipes:
            Label("Recipes", systemImage: "fork.knife.circle")
        case .ai:
            Label("AromAI", systemImage: "face.smiling.fill")
        case .myRecipes:
            Label("My Recipes", systemImage: "frying.pan.fill")
        case .account:
            Label("Account", systemImage: "person.crop.circle")
        }
    }
    
    var title: String {
        switch self {
        case .account:
            return "Profil"
        case .ai:
            return "Yapay Zeka"
        case .myRecipes:
            return "Tariflerim"
        case .recipes:
            return "Tarifler"
        }
    }
    
    var iconName: String {
        switch self {
        case .account:
            return "person"
        case .ai:
            return "face.smiling.fill"
        case .myRecipes:
            return "frying.pan.fill"
        case .recipes:
            return "fork.knife.circle"
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .recipes:
            RecipesNavigationStack()
        case .ai:
            AINavigationStack()
        case .myRecipes:
            MyRecipesNavigationStack()
        case .account:
            AccountNavigationStack()
        }
    }
}
