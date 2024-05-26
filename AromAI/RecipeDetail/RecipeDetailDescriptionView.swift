//
//  RecipeDetailDescriptionView.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI


struct RecipeDetailDescriptionView: View {
    var recipe: RecipeResponse.Recipe
    var body: some View {
        VStack(spacing: 10) {
            ForEach(recipe.recipeSteps.sorted(by: { $0.stepNumber < $1.stepNumber }), id: \.description) { step in
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
