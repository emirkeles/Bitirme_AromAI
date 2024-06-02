//
//  AIRecipeDetailView.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI

struct AIRecipeDetailView: View {
    @Environment(\.userClient) private var userClient
    @State private var selectedSegment = 0
    var recipe: AIRecipe
    
    var body: some View {
        
            ScrollView {
                VStack {
                    Image(.yemek)
                        .resizable()
                        .scaledToFit()
                        
                    Text(recipe.name)
                        .fontWeight(.medium)
                        .font(.title3)
                        .padding(.bottom)
                        .padding(.horizontal)
                    Divider()
                    
                    CapsulePicker(selectedIndex: $selectedSegment, titles: ["Özet", "Malzemeler", "Yapılışı"])
                        .padding()
                        .padding(.horizontal, 15)
                    
                    switch selectedSegment {
                    case 0:
                        AIRecipeDetailSummaryView(recipe: recipe)
                            
                    case 1:
                        AIRecipeDetailIngredientsView(recipe: recipe)
                            
                    case 2:
                        AIRecipeDetailDescriptionView(recipe: recipe)
                            
                    default:
                        EmptyView()
                    }
                }
                
                .scrollIndicators(.hidden)
                .navigationBarTitleDisplayMode(.inline)
            }
            .contentMargins(.bottom, .bottomTabHeight)
    }
}
