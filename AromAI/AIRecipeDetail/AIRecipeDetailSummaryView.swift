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
                .padding(.horizontal)
                
            RecipeDetailSummaryBox(interval: "\(recipe.preparationTime.formatted())", calory: "\(recipe.calories.formatted())", region: "Türkiye")
        }
        
    }
}

//#Preview {
//    AIRecipeDetailSummaryView(recipe: .init(id: "123123", userId: "123123123", createdAt: "123123123", name: "Emir Keleş", description: "Yemek", aiInstructions: [.init(stepNumber: 1, description: "asdfasdf")], preparationTime: 3, servings: 2, calories: 45, protein: 46, fat: 34, carbohydrates: 34, aiIngredients: [.init(name: "name", description: "descp", calories: 35, protein: 45, fat: 23, carbohydrates: 51, quantityType: "Adet", quantity: 2)]))
//}
