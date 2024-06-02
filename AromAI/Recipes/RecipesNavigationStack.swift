//
//  RecipesNavigationStack.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI



struct RecipesNavigationStack: View {
    @Environment(\.userClient) var userClient
    @Environment(\.errorAlert) var errorAlert
    @State var searchText: String = ""
    @State private var recipes: [RecipeResponse.Recipe] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                header
                mealOfTheWeek
                mostLikedMeals
                exploreRecipes
            }
            .task {
                await fetchData()
            }
            .contentMargins(.bottom, .bottomTabHeight)
            .scrollIndicators(.hidden)
        }
    }
    
    func fetchData() async {
        do {
            try await userClient.getRecipes(searchText: nil, page: nil, pageSize: 22)
            try await userClient.getAiRecipes()
//            try await userClient.getCuisines(searchText: nil, page: nil, pageSize: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension RecipesNavigationStack {
    
    var header: some View {
        HStack {
            Image(systemName: "person")
                .font(.title)
                .foregroundStyle(.primaryColor)
            VStack(alignment: .leading) {
                Text("Merhaba ").font(.headline) +
                Text(UserDefaults.standard.string(forKey: "name") ?? "")
                    .foregroundStyle(.primaryColor)
                    .font(.headline)
                Text("Bugün hangi yemeği yapmak istersin?")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.top)
        .padding(.bottom)
    }
    
    var searchBar: some View {
        CustomSearchBar(text: $searchText, prompt: "Tarif ara...")
            .padding()
            .padding(.bottom)
    }
    
    
    var mealOfTheWeek: some View {
        MealOfTheWeekView()
            .padding(.horizontal, 12)
    }
    @ViewBuilder
    var mostLikedMeals: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init()]) {
                    ForEach(userClient.allRecipes.prefix(12)) { recipe in
                        FoodItemView(recipe: recipe)
                    }
                }
                .padding(.horizontal, 12)
            }
            .scrollIndicators(.hidden)
        } header: {
            Text("En Çok Beğenilen Tarifler 🔥")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 8)
                .padding(.horizontal, 12)
        }
    }
    
    @ViewBuilder
    var exploreRecipes: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [.init()]) {
                    ForEach(userClient.allRecipes.reversed().prefix(12)) { recipe in
                        FoodItemView(recipe: recipe)
                    }
                }
                .padding(.horizontal, 12)
            }
            .scrollIndicators(.hidden)
        } header: {
            Text("Yeni Tarifler Keşfedin 🍖")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17, weight: .semibold))
                .padding(.top, 8)
                .padding(.horizontal, 12)
        }
    }
}

extension RecipesNavigationStack {
    struct Meal: Hashable, Identifiable {
        var id = UUID()
        var image: String
    }
    
    struct Categories: Hashable, Identifiable {
        var id = UUID()
        
        var title: String
        var image: String
    }
}



struct FoodItemView: View {
    var recipe: RecipeResponse.Recipe
    var staticUrl = "https://blobcontainerapposite.blob.core.windows.net/mediafiles/mediafiles/079ae404-2049-4a7f-a64a-c1f468d950d0.png"
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            VStack {
                AsyncImage(url: URL(string: recipe.imageUrl ?? staticUrl)!) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .padding(.horizontal, 4)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.quaternary)
                        .frame(width: 100, height: 100)
                        .padding(.horizontal, 4)
                        .overlay {
                            ProgressView()
                        }
                }
                
                Text(recipe.title)
                    .font(.caption)
                    .frame(maxWidth: 100)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 4)
    }
}


struct CategoryView: View {
    var title: LocalizedStringKey
    var image: String
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .frame(width: 56, height: 56)
            .foregroundStyle(.white)
            .shadow(color: Color(red: 149/255, green: 149/255, blue: 149/255, opacity: 0.3), radius: 5, y: 4)
            .overlay(
                VStack {
                    Image(image)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fit)
                    Text(title)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            )
    }
    

}
