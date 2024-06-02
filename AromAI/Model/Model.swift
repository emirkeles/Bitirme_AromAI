//
//  Request.swift
//  AromAI
//
//  Created by Emir Keleş on 28.05.2024.
//

import Foundation

struct PersonalInfoRequest: Codable {
    let ingredients: [String]
    let cuisines: [String]
    let healths: [String]
}

struct MediaRequest: Codable {
    enum FileType: String, Codable {
        case RecipeImage = "RecipeImage"
        case UserProfileImage = "UserProfileImage"
        case IngredientImage = "IngredientImage"
    }
    let jpegData: Data
    let mediaName: String
    let fileType: FileType
}

struct AIRecipeCreationRequest: Codable {
    let cuisine: String?
    let mealType: String?
    let includedIngredients: [String]?
    let excludedIngredients: [String]?
    let health: [String]?
    var language = "Turkish"
    
}


struct RecipeCreationRequest: Codable {
    let coverPhotoId: String?
    let title: String?
    let description: String?
    let preparationTime: Double
    let calories: Double
    let cuisinePreferenceId: String
    let recipeSteps: [RecipeStep]
    let recipeIngredients: [SheetIngredient]
}

struct RecipeStep: Codable {
    let description: String
    let stepNumber: Int
}


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

struct AIRecipeCreationResponse: Codable {
    let data: RecipeData
    
    struct RecipeData: Codable {
        let userId: String
        let name: String
        let description: String
        let aiInstructions: [RecipeStep]
        let preparationTime: Double
        let servings: Int
        let calories: Double
        let protein: Double
        let fat: Double
        let carbohydrates: Double
        let aiIngredients: [AIRecipeIngredient]
    }
}

struct AIRecipeIngredient: Codable {
    let name: String
    let description: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbohydrates: Double
    let quantityType: String
    let quantity: Double
}

struct RegisterResponse: Codable {
    struct InnerRegisterResponse: Codable {
        let id: String
        let name: String
        let surname: String
        let email: String
        let role: String
    }
    let data: InnerRegisterResponse
}

struct Login: Codable {
    var id: Int?
    let email: String
    let password: String
}

struct Register: Codable {
    var id: Int?
    var name: String
    var surname: String
    var email: String
    var userName: String
    var password: String
}

struct Ingredient: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var quantity: String
}

struct MediaResponse: Decodable {
    struct Data: Codable {
        let id: String
    }
    let data: Data
}

struct NewIngredient {
    let id: String
    let name: String
}

struct SheetIngredient: Codable {
    let ingredientId: String
    let quantityType: String
    let quantity: Double
}

struct NewRecipeIngredient: Codable, Hashable {
    var ingredientId: String
    var name: String
    var quantity: Double
    var quantityType: String
    
}


struct TempSteps: Identifiable, Equatable {
    var description: String
    var stepNumber: Int
    
    var id = UUID()
}

struct PersonalInfo: Codable {
    let data: Data
    
    struct Data: Codable {
        let ingredients: [RecipeIngredient]
        let cuisines: [RecipeCuisine]
        let healths: [RecipeHealth]
    }
}
