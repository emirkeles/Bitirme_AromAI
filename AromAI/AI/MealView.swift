//
//  MealView.swift
//  AromAI
//
//  Created by Emir Keleş on 3.04.2024.
//

import SwiftUI

struct MealView: View {
    
    @State private var meals: [Meal] = [
        Meal(name: "Kahvaltı"),
        Meal(name: "Öğle Yemeği"),
        Meal(name: "Akşam Yemeği"),
        Meal(name: "Atıştırmalık"),
    ]
    @State private var selectedMeal: Meal?
    @State private var isLoading = false
    
    @State private var showingAddMealAlert = false
    @State private var newMealName = ""
    
    @Environment(\.userClient) private var userClient
    @Environment(\.errorAlert) private var errorAlert
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        if isLoading {
            VStack {
                CustomProgressView()
            }
        } else {
            VStack {
                ScrollView {
                    Image(.meal1)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 210)
                    
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
                            Text(meal.name)
                                .font(.caption)
                                .minimumScaleFactor(0.8)
                                .padding(8)
                                .foregroundStyle(meal == selectedMeal ? .primaryColor : .black)
                                .frame(maxWidth: .infinity)
                                .background(Capsule().fill(meal == selectedMeal ? .primaryColor.opacity(0.1) : .clear).stroke(meal == selectedMeal ? .primaryColor : .secondaryTextColor, lineWidth: 1))
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
                
                Button(action: {
                    createRecipeByMeal()
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
            .navigationTitle("Öğüne Göre")
            .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}

struct CustomProgressView: View {
    @State private var loadingText = "Yemek oluşturuluyor."
    @State private var dotCount = 1
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primaryColor))
                .scaleEffect(2.0, anchor: .center)
                .padding(20)
            Text(loadingText)
                .font(.headline)
                .foregroundColor(.primaryColor)
                .padding()
                .transition(.slide)
                .frame(width: 220)
        }
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .padding(20)
        .shadow(radius: 10)
        .onReceive(timer) { _ in
            updateLoadingText()
        }
    }
    
    private func updateLoadingText() {
        
            dotCount = (dotCount % 3) + 1
            loadingText = "Yemek oluşturuluyor" + String(repeating: ".", count: dotCount)
        
        }
}


extension MealView {
    private func createRecipeByMeal() {
        isLoading = true
        guard let selected = selectedMeal else { return }
        Task {
            do {
                let recipe = try await userClient.createAiRecipe(aiRecipe: .init(
                    cuisine: nil,
                    mealType: selected.name,
                    includedIngredients: nil,
                    excludedIngredients: nil,
                    health: nil
                ))
                await errorAlert.present(AromAIError.success("\(recipe.data.name) tarifi oluşturuldu."), title: "Başarılı")
                selectedMeal = nil
                isLoading = false
            } catch {
                await errorAlert.present(error, title: "Başarılı")
                isLoading = false
            }
        }
    }
}
