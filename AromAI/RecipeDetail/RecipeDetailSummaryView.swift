//
//  RecipeDetailSummaryView.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI

struct RecipeDetailSummaryView: View {
    var recipe: RecipeResponse.Recipe
    
    var body: some View {
        VStack {
            Text(recipe.description)
            RecipeDetailSummaryBox(interval: "\(recipe.preparationTime)", calory: "\(recipe.calories)", region: recipe.cuisinePreference.name)
        }
        
    }
}
