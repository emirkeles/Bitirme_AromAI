//
//  UserClient.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import Foundation
import SwiftUI

final class DebouncedState<Value>: ObservableObject {
    @Published var currentValue: Value
    @Published var debouncedValue: Value
    
    init(initialValue: Value, delay: Double = 0.3) {
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}

struct PersonalInfoRequest: Codable {
    let ingredients: [String]
    let cuisines: [String]
    let healths: [String]
}

enum Endpoint {
    case login
    case register
    case createRecipe(recipe: RecipeCreationRequest)
    case getRecipes(searchText: String?, page: Int?, pageSize: Int?)
    case getPersonalInfo
    case addPersonalInfo(person: PersonalInfoRequest)
    case createAIRecipe(aiRecipe: AIRecipeCreationRequest)
    case getAIRecipes(page: Int = 0, pageSize: Int = 10)
    case getIngredient(searchText: String?, page: Int?, pageSize: Int?)
    case createIngredient
    case getHealth(searchText: String?, page: Int?, pageSize: Int?)
    case createHealth
    case getCuisine(searchText: String?, page: Int?, pageSize: Int?)
    case createCuisine
    case upload(media: MediaRequest)
    case other
    
    var method: String {
        switch self {
        case .login, .register, .createAIRecipe, .createHealth, .createCuisine, .createIngredient, .createRecipe, .addPersonalInfo, .upload:
            return "POST"
        default:
            return "GET"
        }
    }
    
    static let baseUrl = "https://apposite.live/api"
    
    var path: String {
        switch self {
        case .login:
            return "/Auth/login"
        case .register:
            return "/Auth/register"
        case .getRecipes:
            return "/Recipe/getMyRecipes"
        case .createRecipe:
            return "/Recipe/create"
        case .addPersonalInfo:
            return "/User/addPersonalInfo"
        case .getPersonalInfo:
            return "/User/getPersonalInfo"
        case .createAIRecipe:
            return "/Ai/createAiRecipe"
        case .getAIRecipes:
            return "/Ai/getAiRecipes"
        case .getIngredient:
            return "/Ingredient/get"
        case .createIngredient:
            return "/Ingredient/create"
        case .getHealth:
            return "/Health/get"
        case .createHealth:
           return "/Health/create"
        case .getCuisine:
           return "/CuisinePreference/get"
        case .createCuisine:
           return "/CuisinePreference/create"
        case .upload:
            return "/MediaFile/upload"
        default:
            return ""
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAIRecipes(let page, let pageSize):
            return [
                URLQueryItem(name: "Page", value: "\(page)"),
                URLQueryItem(name: "PageSize", value: "\(pageSize)")
            ]
        case .getIngredient(let searchText, let page, let pageSize),
                .getHealth(let searchText, let page, let pageSize),
                .getCuisine(let searchText, let page, let pageSize),
                .getRecipes(let searchText, let page, let pageSize):
            var queryItemList = [URLQueryItem]()
            if let searchText {
                queryItemList.append(URLQueryItem(name: "SearchText", value: searchText))
            }
            if let page {
                queryItemList.append(URLQueryItem(name: "Page", value: "\(page)"))
            }
            if let pageSize {
                queryItemList.append(URLQueryItem(name: "PageSize", value: "\(pageSize)"))
            }
            return queryItemList
        default:
            return nil
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: Endpoint.baseUrl + self.path)
        components?.queryItems = self.queryItems
        return components?.url
}
    
    var Url: URL? {
        switch self {
        case .getRecipes(let searchText, let page, let pageSize):
            let urlString = Endpoint.baseUrl + self.path + "?SearchText=\(String(describing: searchText))?Page=\(String(describing: page))&PageSize=\(String(describing: pageSize))"
            return URL(string: urlString)
        case .getAIRecipes(let page, let pageSize):
            let urlString = Endpoint.baseUrl + self.path + "?Page=\(page)&PageSize=\(pageSize)"
            return URL(string: urlString)
        default:
            return URL(string: Endpoint.baseUrl + self.path)
        }
        
    }
}

enum NetworkError: LocalizedError {
    case invalidResponse
    case decodingError
    case urlError
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Decode Hatası"
        case .invalidResponse:
            return "Invalid Response Hatası"
        case .urlError:
            return "URL Hatası"
        }
    }
}


struct PersonalInfo: Codable {
    let data: Data
    
    struct Data: Codable {
        let ingredients: [RecipeIngredient]
        let cuisines: [RecipeCuisine]
        let healths: [RecipeHealth]
    }
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

struct AIRecipeCreationRequest: Codable {
    let cuisine: String?
    let mealType: String?
    let includedIngredients: [String]?
    let excludedIngredients: [String]?
    let health: [String]?
    var language = "Turkish"
}

struct RecipeStep: Codable {
    let description: String
    let stepNumber: Int
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




@Observable
class UserClient {
    var bearerToken: String? {
        get {
            UserDefaults.standard.string(forKey: "BearerToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "BearerToken")
        }
    }
    var refreshToken: String?
    var myRecipes: [RecipeResponse.Recipe] = []
    var ingredients: [RecipeIngredient] = []
    var diseases: [RecipeHealth] = []
    var cuisines: [RecipeCuisine] = []
    var ingredientsIds: [String] {
        ingredients.map { ingredient in
            ingredient.id
        }
    }
    var diseasesIds: [String] {
        diseases.map { disease in
            disease.id
        }
    }
    var cuisinesIds: [String] {
        cuisines.map { cuisine in
            cuisine.id
        }
    }
    var myAiRecipes: [AIRecipe] = []
    var allIngredients = [RecipeIngredient]()
    
    
    
    var isValidated = false
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    
    
    struct RegisterResponse: Codable {
        struct innerRegisterResponse: Codable {
            let id: String
            let name: String
            let surname: String
            let email: String
            let role: String
        }
        
        let data: innerRegisterResponse
    }
    
    func getPersonalInfo() async throws{
        let endPoint = Endpoint.getPersonalInfo
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let personalInfo = try JSONDecoder().decode(PersonalInfo.self, from: data)
            ingredients = personalInfo.data.ingredients
            diseases = personalInfo.data.healths
            cuisines = personalInfo.data.cuisines
        } catch {
            throw NetworkError.decodingError
        }
        
    }
    
    func createAiRecipe(aiRecipe recipe: AIRecipeCreationRequest) async throws -> AIRecipeCreationResponse {
        let endpoint = Endpoint.createAIRecipe(aiRecipe: recipe)
        guard let url = endpoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(recipe)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        print(data)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let recipeResponse = try JSONDecoder().decode(AIRecipeCreationResponse.self, from: data)
            print(recipeResponse.data)
            try await getAiRecipes()
            return recipeResponse
        } catch {
            throw NetworkError.decodingError
        }
        
        
    }
    
    func addPersonalInfo(person: PersonalInfoRequest) async throws {
        let endPoint = Endpoint.addPersonalInfo(person: person)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(person)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...210).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    func createRecipe(recipe: RecipeCreationRequest) async throws {
        let endPoint = Endpoint.createRecipe(recipe: recipe)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(recipe)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...210).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    func getRecipes(searchText: String?, page: Int?, pageSize: Int?) async throws -> RecipeResponse {
        let endPoint = Endpoint.getRecipes(searchText: searchText, page: page, pageSize: pageSize)
        
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            myRecipes = recipeResponse.data
            print(myRecipes.count)
            print("yeni veriler eklendi")
            return recipeResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getDiseases(searchText: String?, page: Int?, pageSize: Int?) async throws -> [RecipeHealth] {
        let endPoint = Endpoint.getHealth(searchText: searchText, page: page, pageSize: pageSize)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let myResponse = try JSONDecoder().decode(GenericResponse<RecipeHealth>.self, from: data)
            
            return myResponse.data
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getCuisines(searchText: String?, page: Int?, pageSize: Int?) async throws -> [RecipeCuisine] {
        let endPoint = Endpoint.getCuisine(searchText: searchText, page: page, pageSize: pageSize)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let myResponse = try JSONDecoder().decode(GenericResponse<RecipeCuisine>.self, from: data)
            
            return myResponse.data
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getIngredients(searchText: String?, page: Int?, pageSize: Int?) async throws -> [RecipeIngredient] {
        let endPoint = Endpoint.getIngredient(searchText: searchText, page: page, pageSize: pageSize)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let myResponse = try JSONDecoder().decode(GenericResponse<RecipeIngredient>.self, from: data)
            return myResponse.data
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func getAiRecipes(page: Int = 0, pageSize: Int = 10) async throws -> AIRecipeData {
        let endPoint = Endpoint.getAIRecipes(page: page, pageSize: pageSize)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        print(response)
        do {
            let aiRecipeResponse = try JSONDecoder().decode(AIRecipeData.self, from: data)
            myAiRecipes = aiRecipeResponse.data
            print("ai tarifleri eklendi")
            return aiRecipeResponse
        } catch {
            throw NetworkError.decodingError
        }
    }

    
    func register(with info: Register) async throws {
        let endPoint = Endpoint.register
        guard let url = endPoint.Url else { throw NetworkError.urlError }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(info)
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        guard let response = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        print(response.data)
    }
    
    struct LoginResponse: Codable {
        struct innerLoginResponse: Codable {
            let token: String
            let refreshToken: String
        }
        
        let data: innerLoginResponse
    }
    
    func logout() {
        bearerToken = nil
        refreshToken = nil
        self.isValidated = false
    }
    
    func login(with info: Login) async throws {
        let endPoint = Endpoint.login
        guard let url = endPoint.Url else { throw NetworkError.urlError }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(info)
        request.httpMethod = endPoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        guard let response = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        bearerToken = response.data.token
        refreshToken = response.data.refreshToken
        self.isValidated = true
    }
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

struct ApiResponse: Codable {
    let messages: [String]
}


    
extension UserClient {
    func uploadMediaFile(mediaRequest: MediaRequest) async throws -> MediaResponse {
        let endPoint = Endpoint.upload(media: mediaRequest)
        guard let url = endPoint.url else {
            throw NetworkError.urlError
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // File part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(mediaRequest.jpegData)
        body.append("\r\n".data(using: .utf8)!)
        
        // MediaName part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"MediaName\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(mediaRequest.mediaName)\r\n".data(using: .utf8)!)
        
        // FileType part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"FileType\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(mediaRequest.fileType.rawValue)\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        print(try JSONDecoder().decode(MediaResponse.self, from: data))
        return try JSONDecoder().decode(MediaResponse.self, from: data)
        
    }
}
