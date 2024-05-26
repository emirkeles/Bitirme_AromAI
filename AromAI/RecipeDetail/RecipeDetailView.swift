//
//  CustomSegmentedPicker.swift
//  AromAI
//
//  Created by Emir Keleş on 1.05.2024.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.userClient) private var userClient
    @State private var selectedSegment = 0
    var recipe: RecipeResponse.Recipe
    
    var staticUrl = "https://blobcontainerapposite.blob.core.windows.net/mediafiles/mediafiles/079ae404-2049-4a7f-a64a-c1f468d950d0.png"
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: recipe.imageUrl ?? staticUrl)!) { image in
                image
                    .resizable()
                    .frame(height: 240)
                    .scaledToFit()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.tertiary)
                    .frame(height: 240)
            }
            .padding(.bottom)
            Text(recipe.title)
                .fontWeight(.medium)
                .font(.title3)
                .padding(.bottom)
            Divider()
            
                CapsulePicker(selectedIndex: $selectedSegment, titles: ["Özet", "Malzemeler", "Yapılışı"])
                    .padding()
                    .padding(.horizontal, 15)
            ScrollView {
                switch selectedSegment {
                case 0:
                    RecipeDetailSummaryView(recipe: recipe)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30)
                case 1:
                    RecipeDetailIngredientsView(recipe: recipe)
                        .frame(maxWidth: .infinity)
                case 2:
                    RecipeDetailDescriptionView(recipe: recipe)
                        .frame(maxWidth: .infinity)
                default:
                    EmptyView()
                }
            }
            .scrollIndicators(.hidden)
        }
        .contentMargins(.bottom, .bottomTabHeight)
    }
}



