//
//  AIRecipeDetailDescriptionView.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI


struct AIRecipeDetailDescriptionView: View {
    var recipe: AIRecipe
    var body: some View {
        VStack(spacing: 10) {
            ForEach(recipe.aiInstructions.sorted(by: { $0.stepNumber < $1.stepNumber }), id: \.description) { step in
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.primaryBackground)
                        .overlay(
                            Text("\(step.stepNumber)")
                                .fontWeight(.medium)
                                .foregroundStyle(.primaryColor)
                        )
                    Text(step.description)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                
            }
        }
    }
}

//#Preview {
//    AIRecipeDetailDescriptionView(recipe: .init(id: "123123", userId: "123123123", createdAt: "123123123", name: "Emir Keleş", description: "Yemek", aiInstructions: [.init(stepNumber: 1, description: "asdfasdf")], preparationTime: 3, servings: 2, calories: 45, protein: 46, fat: 34, carbohydrates: 34, aiIngredients: [.init(name: "name", description: "descp", calories: 35, protein: 45, fat: 23, carbohydrates: 51, quantityType: "Adet", quantity: 2)]))
//}
