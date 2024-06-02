//
//  AIModel.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import Foundation

struct AIRecipeData: Codable {
    let data: [AIRecipe]
    let pagination: Pagination
}

struct AIRecipe: Codable {
    let id: String
    let userId: String
    let createdAt: String
    let name: String
    let description: String
    let aiInstructions: [RecipeStep]
    let preparationTime: Double
    let servings: Double
    let calories: Double
    let protein: Double
    let fat: Double
    let carbohydrates: Double
    let aiIngredients: [AIIngredient]
}

struct AIIngredient: Codable {
    let name: String
    let description: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbohydrates: Double
    let quantityType: String
    let quantity: Double
}
