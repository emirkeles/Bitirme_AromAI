//
//  AIRecipeDetailSummaryView.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//
import SwiftUI

struct AIRecipeDetailSummaryView: View {
    var recipe: AIRecipe
    
    var body: some View {
        VStack {
            Text(recipe.description)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
            AIRecipeDetailSummaryBox(interval: "\(recipe.preparationTime.formatted())", calory: "\(recipe.calories.formatted())")
        }
        
    }
}
