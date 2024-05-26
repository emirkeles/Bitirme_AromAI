//
//  AIRecipeDetailIngredientsView.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI

struct AIRecipeDetailIngredientsView: View {
    var recipe: AIRecipe
    @State private var selectedIngredients: Set<String> = []
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(recipe.aiIngredients, id: \.name) { ingredient in
                HStack {
                    Button(action: {
                        toggleSelection(of: ingredient.name)
                    }) {
                        Image(systemName: selectedIngredients.contains(ingredient.name) ? "checkmark.square.fill" : "square")
                            .font(.system(size: 24))
                            .foregroundStyle(selectedIngredients.contains(ingredient.name) ? .primaryColor : .secondary)
                        
                    }
                    Text(ingredient.name)
                        .strikethrough(selectedIngredients.contains(ingredient.name), color: .black)
                        .foregroundStyle(selectedIngredients.contains(ingredient.name) ? .secondary : .primary)
                    Spacer()
                    Text("\(ingredient.quantity.formatted()) \(ingredient.quantityType)")
                        .strikethrough(selectedIngredients.contains(ingredient.name), color: .black)
                        .foregroundStyle(selectedIngredients.contains(ingredient.name) ? .secondary : .primary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    private func toggleSelection(of ingredient: String) {
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
    }
}

//#Preview {
//    AIRecipeDetailIngredientsView(recipe: .init(id: "123123", userId: "123123123", createdAt: "123123123", name: "Emir Keleş", description: "Yemek", aiInstructions: [.init(stepNumber: 1, description: "asdfasdf")], preparationTime: 3, servings: 2, calories: 45, protein: 46, fat: 34, carbohydrates: 34, aiIngredients: [.init(name: "name", description: "descp", calories: 35, protein: 45, fat: 23, carbohydrates: 51, quantityType: "Adet", quantity: 2)]))
//}
