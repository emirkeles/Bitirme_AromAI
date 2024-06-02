//
//  UserClient.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import Foundation
import SwiftUI

enum Endpoint {
    case login
    case register
    case createRecipe(recipe: RecipeCreationRequest)
    case getRecipes(searchText: String?, page: Int?, pageSize: Int?)
    case getMyRecipes(searchText: String?, page: Int?, pageSize: Int?)
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
            return "/Recipe/get"
        case .getMyRecipes:
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
                .getRecipes(let searchText, let page, let pageSize),
                .getMyRecipes(let searchText, let page, let pageSize):
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
}

enum NetworkError: LocalizedError {
    case invalidResponse
    case decodingError
    case urlError
    
    var errorDescription: LocalizedStringKey {
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
    var useMyInfo: Bool = false
    var name: String = ""
    var email: String = ""
    
    var allRecipes: [RecipeResponse.Recipe] = []
    var myRecipes: [RecipeResponse.Recipe] = []
    var ingredients: [RecipeIngredient] = []
    var diseases: [RecipeHealth] = []
    var cuisines: [RecipeCuisine] = []
    var allCuisines: [RecipeCuisine] = []
    
    
    var cuisine: String? {
        cuisines.first?.name ?? nil
    }
    var diseasesNames: [String] {
        diseases.map { disease in
            disease.name
        }
    }
    var ingredientsNames: [String] {
        ingredients.map { ingredient in
            ingredient.name
        }
    }
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
    var allCuisinesIds: [String] {
        allCuisines.map { cuisine in
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
        
        
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let recipeResponse = try JSONDecoder().decode(AIRecipeCreationResponse.self, from: data)
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
        
        guard let httpResponse = response as? HTTPURLResponse, (200...210).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    func getMyRecipes(searchText: String?, page: Int?, pageSize: Int?) async throws -> RecipeResponse {
        let endPoint = Endpoint.getMyRecipes(searchText: searchText, page: page, pageSize: pageSize)
        
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
            return recipeResponse
        } catch {
            throw NetworkError.decodingError
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
            allRecipes = recipeResponse.data
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
            self.allCuisines = myResponse.data
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
        do {
            let aiRecipeResponse = try JSONDecoder().decode(AIRecipeData.self, from: data)
            myAiRecipes = aiRecipeResponse.data
            return aiRecipeResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    
    func register(with info: Register) async throws {
        let endPoint = Endpoint.register
        guard let url = endPoint.url else { throw NetworkError.urlError }
        
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
        guard let url = endPoint.url else { throw NetworkError.urlError }
        
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
        let a = decode(jwtToken: response.data.token)
        name = a["name"] as? String ?? ""
        email = a["email"] as? String ?? ""
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(email, forKey: "email")
        self.isValidated = true
    }
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
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        return try JSONDecoder().decode(MediaResponse.self, from: data)
        
    }
}
