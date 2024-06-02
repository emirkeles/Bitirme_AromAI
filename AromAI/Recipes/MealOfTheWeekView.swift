//
//  MealOfTheWeekView.swift
//  AromAI
//
//  Created by Emir Keleş on 28.03.2024.
//

import SwiftUI

struct MealOfTheWeekView: View {
    var staticUrl =  "https://blobcontainerapposite.blob.core.windows.net/mediafiles/mediafiles/079ae404-2049-4a7f-a64a-c1f468d950d0.png"
    
    @State var foods: [RecipeResponse.Recipe]?
    @Environment(\.userClient) private var userClient
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(userClient.allRecipes.prefix(5)) { food in
                    NavigationLink {
                        RecipeDetailView(recipe: food)
                    } label: {
                        MealCardView(food: food, staticUrl: staticUrl)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(x: phase.isIdentity ? 1.0 : 0.2,
                                                 y: phase.isIdentity ? 1.0 : 0.2)
                                    .offset(y: phase.isIdentity ? 0 : 50)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}


struct MealCardView: View {
    var food: RecipeResponse.Recipe
    var staticUrl: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: food.imageUrl ?? staticUrl)!) { image in
                image
                    .resizable()
                    .aspectRatio(1.6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14).fill(.black.gradient.opacity(0.4)))
            } placeholder: {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(.tertiary)
                    .aspectRatio(1.6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        ProgressView()
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(food.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(food.description)
                    .font(.system(size: 12))
                    .frame(maxWidth: 280, alignment: .leading)
                    .foregroundColor(.white)
                Label(
                    title: { Text("\(food.user.name)  \(food.user.surname)") },
                    icon: { Image(systemName: "person") }
                )
                .foregroundStyle(.white.opacity(0.6))
                .font(.subheadline)
            }
            .padding()
        }
        //        .frame(width: UIScreen.main.bounds.width * 0.8)
    }
}
