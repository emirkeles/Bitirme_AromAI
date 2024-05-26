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
        VStack {
            Image(.yemek)
                .resizable()
                .frame(height: 240)
                .scaledToFill()
            Text(recipe.name)
                .fontWeight(.medium)
                .font(.title3)
                .padding(.bottom)
            Divider()
            
                CapsulePicker(selectedIndex: $selectedSegment, titles: ["Özet", "Malzemeler", "Yapılışı"])
                .padding(.top)
                .padding(.bottom, 4)
            
            ScrollView {
                switch selectedSegment {
                case 0:
                    AIRecipeDetailSummaryView(recipe: recipe)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30)
                case 1:
                    AIRecipeDetailIngredientsView(recipe: recipe)
                        .frame(maxWidth: .infinity)
                case 2:
                    AIRecipeDetailDescriptionView(recipe: recipe)
                        .frame(maxWidth: .infinity)
                default:
                    EmptyView()
                }
            }
            .scrollIndicators(.hidden)
        }
        .offset(y: -40)
    }
}
