//
//  RegionVie.swift
//  AromAI
//
//  Created by Emir Keleş on 3.04.2024.
//

import SwiftUI

struct RegionView: View {
    @State private var likedKitchens: [LikedKitchen] = Constants.likedKitchens
    @State private var selectedKitchen: LikedKitchen?
    @Environment(\.errorAlert) private var errorAlert
    @Environment(\.userClient) private var userClient
    
    let columns = [
        GridItem(.adaptive(minimum: 100)),
    ]
    @State private var showingAddRegionAlert = false
    @State private var newRegionName = ""
    
    @State private var isLoading = false
    
    var body: some View {
        if isLoading {
            VStack {
                CustomProgressView()
            }
        } else {
            VStack {
                ScrollView {
                    Image(.region1)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 220)
                    
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
                
                Button(action: { createRecipeByKitchen() },
                       label: {
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
            
            .navigationTitle("Bölgeye Göre")
            .navigationBarTitleDisplayMode(.inline)
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
        }
    }
}

extension RegionView {
    private func createRecipeByKitchen() {
        
        Task {
            do {
                guard let selected = selectedKitchen else { throw AromAIError.custom }
                isLoading = true
                let recipe = try await userClient.createAiRecipe(aiRecipe: .init(
                    cuisine: selected.name,
                    mealType: nil,
                    includedIngredients: nil,
                    excludedIngredients: userClient.useMyInfo ? userClient.ingredientsNames : nil,
                    health: userClient.useMyInfo ? userClient.diseasesNames : nil
                ))
                isLoading = false
                selectedKitchen = nil
                await errorAlert.present(AromAIError.success("\(recipe.data.name) tarifi oluşturuldu."), title: "Başarılı")
            } catch {
                isLoading = false
                await errorAlert.present(error)
            }
        }
    }
}

#Preview {
    RegionView()
        .preferredColorScheme(.light)
}


#Preview {
    RegionView()
        .preferredColorScheme(.dark)
}
