//
//  IngredientsView.swift
//  AromAI
//
//  Created by Emir Keleş on 3.04.2024.
//

import SwiftUI

struct IngredientsView: View {
    @State private var allergies: [Allergy] = [
        Allergy(name: "🍅 Domates"),
        Allergy(name: "🍎 Elma"),
        Allergy(name: "🥕 Havuç"),
        Allergy(name: "🍌 Muz"),
        Allergy(name: "🍐 Armut"),
        Allergy(name: "🍋 Limon"),
        Allergy(name: "🍊 Portakal"),
        Allergy(name: "🍉 Karpuz"),
        Allergy(name: "🍓 Çilek"),
    ]
    @State private var selectedAllergies: [Allergy] = []
    @State private var isLoading = false
    
    @State private var showingAddIngredientAlert = false
    @State private var newIngredientName = ""
    @Environment(\.errorAlert) private var errorAlert
    @Environment(\.userClient) private var userClient
    
    
    let columns = [
        GridItem(.adaptive(minimum: 100)),
    ]
    var body: some View {
        if isLoading {
            VStack {
                CustomProgressView()
            }
        } else {
            VStack {
                ScrollView {
                    Image(.ingredients1)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 210)
                    
                    Text("Malzemelerinizi Seçin")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    Text("Aşağıda bulunan malzemelerden istediğinizi seçiniz. \nYapay zeka bu seçilen malzemelerrden göre yemek önerecektir. ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    LazyVGrid(columns: columns) {
                        ForEach(allergies) { allergy in
                            Text(allergy.name)
                                .font(.caption)
                                .minimumScaleFactor(0.8)
                                .padding(8)
                                .foregroundStyle(selectedAllergies.contains(allergy) ? .primaryColor : .black)
                                .fontWeight(selectedAllergies.contains(allergy) ? .semibold : nil)
                                .frame(maxWidth: .infinity)
                                .background(Capsule().fill(selectedAllergies.contains(allergy) ? .primaryColor.opacity(0.1) : .clear).stroke(selectedAllergies.contains(allergy) ? .primaryColor : .secondaryTextColor, lineWidth: 1))
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
                
                Button(action: {
                    createRecipeByIngredients()
                }, label: {
                    Text("Yemek Tarifi Oluştur")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .padding()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(.primaryColor)
                        .clipShape(.buttonBorder)
                })
                .padding(.horizontal)
                .frame(height: .bottomTabHeight, alignment: .top)
            }
            
            .navigationTitle("Malzemeye Göre")
            .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}

extension IngredientsView {
    private func createRecipeByIngredients() {
        isLoading = true
        let selectedIngredientNames = selectedAllergies.map { $0.name }
        Task {
            do {
                let recipe = try await userClient.createAiRecipe(aiRecipe: .init(
                        cuisine: nil,
                        mealType: nil,
                        includedIngredients: selectedIngredientNames,
                        excludedIngredients: nil,
                        health: nil
                    ))
                await errorAlert.present(AromAIError.success("\(recipe.data.name) tarifi oluşturuldu."), title: "Başarılı")
                isLoading = false
                selectedAllergies = []
            } catch {
                await errorAlert.present(error, title: "Hata")
                isLoading = false
            }
        }
    }
}
