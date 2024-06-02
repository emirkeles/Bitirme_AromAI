//
//  MyRecipesNavigationStack.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

struct MyRecipesNavigationStack: View {
    enum Recipes: LocalizedStringKey {
        case recipes = "Tarifler"
        case aiRecipes = "AI Tariflerim"
        case myRecipes = "Tariflerim"
    }
    @Environment(\.userClient) private var userClient
    @State private var searchText = ""
    @State private var newRecipe = false
    @State private var navigationTitle: Recipes = .recipes
    @StateObject private var debouncedSearchText = DebouncedState(initialValue: "")
    @State var myRecipes = [RecipeResponse.Recipe]()
    @State var allRecipes = [RecipeResponse.Recipe]()
    
    func getMyRecipes(searchText: String?) {
        Task {
            do {
                let recipes = try await userClient.getMyRecipes(searchText: searchText, page: nil, pageSize: 22)
                myRecipes = recipes.data
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getRecipes(searchText: String?) {
        Task {
            do {
                let recipes = try await userClient.getRecipes(searchText: searchText, page: nil, pageSize: 22)
                allRecipes = recipes.data
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    if navigationTitle == .recipes {
                        allRecipeList
                    } else if navigationTitle == .aiRecipes {
                        aiRecipeList
                    } else {
                        recipeList
                    }
                }
                .task {
                    getRecipes(searchText: nil)
                    getMyRecipes(searchText: nil)
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                .navigationTitle(navigationTitle.rawValue)
                .searchable(text: $debouncedSearchText.currentValue, prompt: "Tarif ara...")
                .textInputAutocapitalization(.never)
                .onChange(of: debouncedSearchText.debouncedValue) { _, newValue in
                    if navigationTitle == .recipes {
                        getRecipes(searchText: newValue == "" ? nil : newValue)
                    } else if navigationTitle == .myRecipes {
                        getMyRecipes(searchText: newValue == "" ? nil : newValue)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            if navigationTitle == .recipes {
                                aiRecipesButton
                                myRecipesButton
                            }
                            else if navigationTitle == .myRecipes {
                                aiRecipesButton
                                recipesButton
                            } else {
                                recipesButton
                                myRecipesButton
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                newRecipe = true
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .frame(width: 32, height: 32)
                                            .foregroundStyle(.primaryColor)
                                            .shadow(color: Color(red: 79/255, green: 78/255, blue: 78/255, opacity: 0.3), radius: 5, y: 4))
                            })
                            .padding(.trailing, 10)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(.bottom, .bottomTabHeight)
            .refreshable {
                Task {
                    do {
                        try await userClient.getAiRecipes()
                        getMyRecipes(searchText: nil)
                        getRecipes(searchText: nil)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
            .sheet(isPresented: $newRecipe) {
                NewRecipeSheet(sheetPresentation: $newRecipe)
            }
        }
    }
    
    private var recipesButton: some View {
        Button {
            navigationTitle = .recipes
        } label: {
            Label("Tarifler", systemImage: "book")
        }
    }
    
    private var aiRecipesButton: some View {
        Button {
            navigationTitle = .aiRecipes
        } label: {
            Label("AI Tariflerim", systemImage: "brain.head.profile")
                .foregroundStyle(.primaryColor, .primaryColor)
        }
    }
    
    private var myRecipesButton: some View {
        Button {
            navigationTitle = .myRecipes
        } label: {
            Label("Tariflerim", systemImage: "book.fill")
                .foregroundStyle(.primaryColor, .clear)
        }
    }
    
    @ViewBuilder
    private var allRecipeList: some View {
        ForEach(allRecipes, id: \.id) { recipe in
            NavigationLink{
                RecipeDetailView(recipe: recipe)
            } label: {
                RecipeItemView(recipe: recipe)
            }
            
        }
    }
    
    @ViewBuilder
    private var recipeList: some View {
        ForEach(myRecipes, id: \.id) { recipe in
            NavigationLink {
                RecipeDetailView(recipe: recipe)
            } label: {
                RecipeItemView(recipe: recipe)
            }
        }
    }
    
    @ViewBuilder
    private var aiRecipeList: some View {
        ForEach(filteredAiRecipes, id: \.id) { recipe in
            NavigationLink {
                AIRecipeDetailView(recipe: recipe)
            } label: {
                AIRecipeItemView(recipe: recipe)
            }
        }
    }
    
    var filteredAiRecipes: [AIRecipe] {
        if debouncedSearchText.currentValue.isEmpty {
            return userClient.myAiRecipes
        } else {
            return userClient.myAiRecipes.filter { $0.name.localizedCaseInsensitiveContains(debouncedSearchText.currentValue) }
        }
    }
}

struct RecipeItemView: View {
    var recipe: RecipeResponse.Recipe
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: recipe.imageUrl ?? "https://blobcontainerapposite.blob.core.windows.net/mediafiles/mediafiles/079ae404-2049-4a7f-a64a-c1f468d950d0.png")!) { image in
                image
                    .resizable()
                    .frame(width: 110, height: 80)
                    .cornerRadius(14)
            } placeholder: {
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 110, height: 80)
                    .foregroundStyle(.quinary)
                    .overlay {
                        ProgressView()
                    }
            }
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .fontWeight(.medium)
                Text(recipe.description)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
    }
}


struct AIRecipeItemView: View {
    var recipe: AIRecipe
    
    var body: some View {
        HStack {
            Image(.yemek6)
                .resizable()
                .frame(width: 110, height: 80)
                .cornerRadius(14)
            
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .fontWeight(.medium)
                Text(recipe.description)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
    }
}
