//
//  AIModel.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import Foundation

struct AIRecipeData: Codable {
    let data: [AIRecipe]
    let pagination: AIPagination
}

struct AIRecipe: Codable {
    let id: String
    let userId: String
    let createdAt: String
    let name: String
    let description: String
    let aiInstructions: [AIInstruction]
    let preparationTime: Double
    let servings: Double
    let calories: Double
    let protein: Double
    let fat: Double
    let carbohydrates: Double
    let aiIngredients: [AIIngredient]
}

struct AIInstruction: Codable {
    let stepNumber: Int
    let description: String
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

struct AIPagination: Codable {
    let pageNumber: Int
    let pageSize: Int
    let totalPages: Int
    let totalRecords: Int
}
