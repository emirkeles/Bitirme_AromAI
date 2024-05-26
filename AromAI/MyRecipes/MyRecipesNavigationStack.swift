//
//  MyRecipesNavigationStack.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI


struct MyRecipesNavigationStack: View {
    enum Recipes: String {
        case recipes = "Tariflerim"
        case aiRecipes = "AI Tariflerim"
        
    }
    @Environment(\.userClient) private var userClient
    @State private var searchText = ""
    @State private var newRecipe = false
    @State private var navigationTitle: Recipes = .recipes
    @StateObject private var debouncedSearchText = DebouncedState(initialValue: "")
    @State var myRecipes = [RecipeResponse.Recipe]()
    @State var myAıRecipes = [AIRecipe]()
    
    func getRecipes(searchText: String?) {
        Task {
            do {
                let recipes = try await userClient.getRecipes(searchText: searchText, page: nil, pageSize: nil)
                myRecipes = recipes.data
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
                        recipeList()
                    } else {
                        aiRecipeList()
                    }
                }
                .task {
                    getRecipes(searchText: nil)
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
                .navigationTitle(navigationTitle.rawValue)
                .searchable(text: $debouncedSearchText.currentValue, prompt: "Tarif ara...")
                .textInputAutocapitalization(.never)
                .onChange(of: debouncedSearchText.debouncedValue) { oldValue, newValue in
                    if navigationTitle == .recipes {
                        getRecipes(searchText: newValue == "" ? nil : newValue)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button {
                                if navigationTitle == .recipes {
                                    withAnimation {
                                        navigationTitle = .aiRecipes
                                    }
                                } else {
                                    withAnimation {
                                        navigationTitle = .recipes
                                    }
                                    
                                }
                            } label: {
                                if navigationTitle == .recipes {
                                    Label("AI Tariflerim", systemImage: "book")
                                } else {
                                    Label("Tariflerim", systemImage: "book.fill")
                                }
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
    
    @ViewBuilder
    private func recipeList() -> some View {
        ForEach(myRecipes, id: \.id) { recipe in
            NavigationLink {
                RecipeDetailView(recipe: recipe)
            } label: {
                RecipeItemView(recipe: recipe)
            }
        }
    }
    
    @ViewBuilder
    private func aiRecipeList() -> some View {
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
    
//    var filteredRecipes: [RecipeResponse.Recipe] {
//        if searchText.isEmpty {
//            return userClient.myRecipes
//        } else {
//            return userClient.myRecipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        }
//    }
}

struct RecipeItemView: View {
    var recipe: RecipeResponse.Recipe
    
    var body: some View {
        HStack {
//            AsyncImage(url: URL(string: recipe.imageUrl)!) { image in
//                image
//                    .resizable()
//                    .frame(width: 110, height: 80)
//                    .cornerRadius(14)
//            } placeholder: {
//                RoundedRectangle(cornerRadius: 14)
//                    .frame(width: 110, height: 80)
//                    .foregroundStyle(.quinary)
//                    .overlay {
//                        ProgressView()
//                    }
//            }
            Image(.yemek6)
                .resizable()
                .frame(width: 110, height: 80)
                .cornerRadius(14)
            
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .fontWeight(.medium)
                Text(recipe.description)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
//                HStack {
//                    Text(recipe.difficulty.rawValue)
//                        .font(.system(size: 10))
//                        .padding(.horizontal, 5)
//                        .padding(.vertical, 2)
//                        .foregroundStyle(Color(red: 0, green: 152/255, blue: 121/255))
//                        .background(Color(red: 0, green: 152/255, blue: 121/255, opacity: 0.15))
//                        .cornerRadius(2.5)
//                    Text(recipe.interval)
//                        .font(.system(size: 10))
//                        .padding(.horizontal, 5)
//                        .padding(.vertical, 2)
//                        .foregroundStyle(Color(red: 255/255, green: 193/255, blue: 7/255))
//                        .background(Color(red: 255/255, green: 193/255, blue: 7/255, opacity: 0.15))
//                        .cornerRadius(2.5)
//                }
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
//            AsyncImage(url: URL(string: recipe.imageUrl)!) { image in
//                image
//                    .resizable()
//                    .frame(width: 110, height: 80)
//                    .cornerRadius(14)
//            } placeholder: {
//                RoundedRectangle(cornerRadius: 14)
//                    .frame(width: 110, height: 80)
//                    .foregroundStyle(.quinary)
//                    .overlay {
//                        ProgressView()
//                    }
//            }
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
//                HStack {
//                    Text(recipe.difficulty.rawValue)
//                        .font(.system(size: 10))
//                        .padding(.horizontal, 5)
//                        .padding(.vertical, 2)
//                        .foregroundStyle(Color(red: 0, green: 152/255, blue: 121/255))
//                        .background(Color(red: 0, green: 152/255, blue: 121/255, opacity: 0.15))
//                        .cornerRadius(2.5)
//                    Text(recipe.interval)
//                        .font(.system(size: 10))
//                        .padding(.horizontal, 5)
//                        .padding(.vertical, 2)
//                        .foregroundStyle(Color(red: 255/255, green: 193/255, blue: 7/255))
//                        .background(Color(red: 255/255, green: 193/255, blue: 7/255, opacity: 0.15))
//                        .cornerRadius(2.5)
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .padding(.vertical, 5)
    }
}
