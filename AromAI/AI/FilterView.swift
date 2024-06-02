//
//  FilterView.swift
//  AromAI
//
//  Created by Emir Keleş on 3.04.2024.
//

import SwiftUI

struct FilterView: View {
    @State private var meals: [Meal] = Constants.meals
    @State private var selectedMeal: Meal?
    @State private var allergies: [Allergy] = Constants.allergies
    @State private var selectedAllergies: [Allergy] = []
    @State private var likedKitchens: [LikedKitchen] = Constants.likedKitchens
    @State private var selectedKitchen: LikedKitchen?
    @State private var sheetPresented = false
    @State private var addMeal = true
    @State private var addIngredient = true
    @State private var addRegion = true
    
    @State private var showingAddRegionAlert = false
    @State private var newRegionName = ""
    
    @State private var showingAddMealAlert = false
    @State private var newMealName = ""
    
    @State private var showingAddIngredientAlert = false
    @State private var newIngredientName = ""
    
    @Environment(\.errorAlert) private var errorAlert
    @Environment(\.userClient) private var userClient
    
    @State private var isLoading = false
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        if isLoading {
            VStack {
                CustomProgressView()
            }
        } else {
            VStack {
                if !(addMeal || addIngredient || addRegion) {
                    ContentUnavailableView("Hiçbir filtre bulunamadı", systemImage: "fork.knife", description: Text("Listelenmesi için bir filtre ekle"))
                        .frame(maxHeight: .infinity, alignment: .center)
                }
                ScrollView {
                    filteredViews
                }
                HStack {
                    Button(action: {
                        createRecipeByFilter()
                    }, label: {
                        Text("Yemek Tarifi Oluştur")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .padding()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .background(.primaryColor)
                            .clipShape(.buttonBorder)
                    })
                    
                }
                .frame(height: 120, alignment: .top)
                .padding(.horizontal)
            }
            .navigationTitle("Filtreye Göre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        sheetPresented = true
                    }, label: {
                        Text("+ Filtre Ekle")
                            .foregroundStyle(.primaryColor)
                            .font(.headline)
                    })
                    .padding(.trailing)
                }
            }
            .alert("Yeni Bölge Ekle", isPresented: $showingAddRegionAlert) {
                TextField("Bölge ismi girin...", text: $newRegionName)
                Button("İptal", role: .cancel) { newRegionName = "" }
                Button("Kaydet") {
                    let trimmedName = newRegionName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        withAnimation(.bouncy) {
                            likedKitchens.append(LikedKitchen(name: trimmedName))
                            newRegionName = ""
                        }
                    }
                }
            }
            .alert("Yeni Öğün Ekle", isPresented: $showingAddMealAlert) {
                TextField("Öğün ismi girin...", text: $newMealName)
                Button("İptal", role: .cancel) { newMealName = "" }
                Button("Kaydet") {
                    let trimmedName = newMealName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        withAnimation(.bouncy) {
                            meals.append(Meal(name: trimmedName))
                            newMealName = ""
                        }
                    }
                }
            }
            .alert("Yeni Malzeme Ekle", isPresented: $showingAddIngredientAlert) {
                TextField("Malzeme ismi girin...", text: $newIngredientName)
                Button("İptal", role: .cancel) { newIngredientName = "" }
                Button("Kaydet") {
                    let trimmedName = newIngredientName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        withAnimation(.bouncy) {
                            allergies.append(.init(name: trimmedName))
                            newIngredientName = ""
                        }
                    }
                }
            }
            .sheet(isPresented: $sheetPresented) {
                SheetView(addMeal: $addMeal, addIngredient: $addIngredient, addRegion: $addRegion)
            }
        }
    }
}


extension FilterView {
    
    @ViewBuilder
    var addRegionView: some View {
        Text("Bölge Seçin")
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        Text("Aşağıda bulunan bölgelerden istediğinizi seçiniz. \nYapay zeka bu seçilen bölgelere göre yemek önerecektir. ")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .padding(.leading)
        LazyVGrid(columns: columns) {
            ForEach(likedKitchens) { kitchen in
                Text(LocalizedStringKey(stringLiteral: kitchen.name))
                    .font(.caption)
                    .foregroundStyle(selectedKitchen == kitchen ? .primaryColor : .primary)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(selectedKitchen == kitchen ? .primaryColor.opacity(0.1) : .secondary.opacity(0.1)).stroke(selectedKitchen == kitchen ? .primaryColor : .secondaryTextColor, lineWidth: 1))
                    .onTapGesture {
                        selectedKitchen = (selectedKitchen == kitchen) ? nil : kitchen
                    }
            }
            Button(action: {
                showingAddRegionAlert = true
            }, label: {
                Text("+ Ekle")
                    .foregroundStyle(.primaryDark)
                    .font(.caption)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(.primaryColor.opacity(0.15)).stroke(.primaryColor, lineWidth: 1))
            })
            .buttonStyle(.plain)
        }
        .padding()
    }
    
    @ViewBuilder
    var addMealView: some View {
        Text("Öğün Seçin")
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        Text("Aşağıda bulunan öğünlerden istediğinizi seçiniz. \nYapay zeka bu seçilen öğüne göre yemek önerecektir. ")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .padding(.leading)
        LazyVGrid(columns: columns) {
            ForEach(meals) { meal in
                Text(LocalizedStringKey(stringLiteral: meal.name))
                    .font(.caption)
                    .minimumScaleFactor(0.8)
                    .padding(8)
                    .foregroundStyle(meal == selectedMeal ? .primaryColor : .primary)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(meal == selectedMeal ? .primaryColor.opacity(0.1) : .secondary.opacity(0.1)).stroke(meal == selectedMeal ? .primaryColor : .secondaryTextColor, lineWidth: 1))
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            selectedMeal = (selectedMeal == meal) ? nil : meal
                        }
                    }
            }
            Button(action: {
                showingAddMealAlert = true
            }, label: {
                Text("+ Ekle")
                    .foregroundStyle(.primaryDark)
                    .font(.caption)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(.primaryColor.opacity(0.15)).stroke(.primaryColor, lineWidth: 1))
            })
            .buttonStyle(.plain)
        }
        .padding()
    }
    
    @ViewBuilder
    var addIngredientView: some View {
        Text("Malzemelerinizi Seçin")
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        Text("Aşağıda bulunan malzemelerden istediğinizi seçiniz. \nYapay zeka bu seçilen malzemelere göre yemek önerecektir. ")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .padding(.leading)
        LazyVGrid(columns: columns) {
            ForEach(allergies) { allergy in
                Text(LocalizedStringKey(stringLiteral: allergy.name))
                    .font(.caption)
                    .minimumScaleFactor(0.8)
                    .padding(8)
                    .foregroundStyle(selectedAllergies.contains(allergy) ? .primaryColor : .primary)
                    .fontWeight(selectedAllergies.contains(allergy) ? .semibold : nil)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(selectedAllergies.contains(allergy) ? .primaryColor.opacity(0.1) : .secondary.opacity(0.1)).stroke(selectedAllergies.contains(allergy) ? .primaryColor : .secondaryTextColor, lineWidth: 1))
                    .onTapGesture {
                        if let index = selectedAllergies.firstIndex(of: allergy) {
                            selectedAllergies.remove(at: index)
                        } else {
                            selectedAllergies.append(allergy)
                        }
                    }
            }
            Button(action: {
                showingAddIngredientAlert = true
            }, label: {
                Text("+ Ekle")
                    .foregroundStyle(.primaryDark)
                    .font(.caption)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(.primaryColor.opacity(0.15)).stroke(.primaryColor, lineWidth: 1))
            })
            .buttonStyle(.plain)
        }
        .padding()
    }
    
    @ViewBuilder
    var filteredViews: some View {
        if addMeal || addIngredient || addRegion {
            Image(.filter1)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 80)
        } else {
        }
        if addMeal {
            addMealView
        }
        if addIngredient {
            addIngredientView
        }
        
        if addRegion {
            addRegionView
        }
    }
}



struct SheetView: View {
    @Binding var addMeal: Bool
    @Binding var addIngredient: Bool
    @Binding var addRegion: Bool
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            List {
                Toggle("Öğün Ekle", isOn: $addMeal)
                Toggle("Malzeme Ekle", isOn: $addIngredient)
                Toggle("Bölge Ekle", isOn: $addRegion)
            }
            .tint(.primaryColor)
            .navigationTitle("Filtre Ekle")
            .toolbar {
                Button("Tamam") {
                    dismiss()
                }
            }
        }
    }
}

extension FilterView {
    private func createRecipeByFilter() {
        isLoading = true
        guard let guardKitchen = selectedKitchen else { return }
        guard let guardMeal = selectedMeal else { return }
        let selectedIngredientNames = selectedAllergies.map { $0.name }
        Task {
            do {
                let recipe = try await userClient.createAiRecipe(aiRecipe: .init(
                    cuisine: guardKitchen.name,
                    mealType: guardMeal.name,
                    includedIngredients: selectedIngredientNames,
                    excludedIngredients: userClient.useMyInfo ? userClient.ingredientsNames : nil,
                    health: userClient.useMyInfo ? userClient.diseasesNames : nil
                ))
                isLoading = false
                await errorAlert.present(AromAIError.success("\(recipe.data.name) tarifi oluşturuldu."), title: "Başarılı")
                selectedAllergies = []
                selectedMeal = nil
                selectedKitchen = nil
            } catch {
                isLoading = false
                await errorAlert.present(error, title: "Hata")
                
            }
        }
    }
}
