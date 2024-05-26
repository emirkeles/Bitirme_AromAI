//
//  Model.swift
//  AromAI
//
//  Created by Emir Keleş on 1.05.2024.
//

import SwiftUI

struct RecipeIngredient: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    let description: String
    let calories: Double
    let protein: Double
    let fat: Double
    let imageUrl: String?
}

struct RecipeCuisine: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}

struct RecipeHealth: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}

struct RecipeResponse: Codable {
    struct Recipe: Codable, Identifiable {
        let id: String
        let title: String
        let description: String
        let preparationTime: Int
        let calories: Int
        let imageUrl: String?
        let user: User
        let cuisinePreference: CuisinePreference
        let recipeSteps: [RecipeStep]
        let recipeIngredients: [RecipeIngredient]
    }
    
    struct User: Codable {
        let id: String
        let name: String
        let surname: String
    }
    
    struct CuisinePreference: Codable {
        let id: String
        let name: String
        let description: String
    }
    
    struct RecipeStep: Codable {
        let stepNumber: Int
        let description: String
    }
    
    struct RecipeIngredient: Codable {
        let id: String
        let name: String
        let description: String
        let calories: Double
        let protein: Double
        let fat: Double
        let quantityType: String
        let quantity: Double
        let imageUrl: String
    }
    
    let data: [Recipe]
    let pagination: Pagination
}

struct GenericResponse<T: Codable>: Codable {
    let data: [T]
    let pagination: Pagination
}

struct IngredientResponse: Codable {
    let data: [RecipeIngredient]
    let pagination: Pagination
}

struct HealthResponse: Codable {
    let data: [RecipeHealth]
    let pagination: Pagination
}

struct Pagination: Codable {
    let pageNumber: Int
    let pageSize: Int
    let totalPages: Int
    let totalRecords: Int
}

