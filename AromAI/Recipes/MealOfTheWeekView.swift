//
//  MealOfTheWeekView.swift
//  AromAI
//
//  Created by Emir Keleş on 28.03.2024.
//

import SwiftUI

struct Food {
    var title: String
    var image: String
    var caption: String
    var person: String
}

struct MealOfTheWeekView: View {
    var staticUrl =  "https://blobcontainerapposite.blob.core.windows.net/mediafiles/mediafiles/079ae404-2049-4a7f-a64a-c1f468d950d0.png"
    
    var food: RecipeResponse.Recipe?
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let food {
                AsyncImage(url: URL(string: food.imageUrl ?? staticUrl)!) { image in
                    image
                        .resizable()
                        .aspectRatio(1.6, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14).fill(.black.gradient.opacity(0.4)))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.tertiary)
                        .aspectRatio(1.6, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 14))
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
                        title: { Text("\(food.user.name) \(food.user.surname)") },
                        icon: { Image(systemName: "person") }
                    )
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.subheadline)
                }
                .padding()
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .aspectRatio(1.6, contentMode: .fit)
                    .foregroundStyle(.tertiary)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay(
                        ProgressView()
                    )
            }
            
            
            //            Image(food.imageUrl)
            //                .resizable()
            //                .scaledToFit()
            //                .clipShape(.rect(cornerRadius: 14))
            //                .overlay(
            //                    RoundedRectangle(cornerRadius: 14).fill(.black.opacity(0.2))
            //                )
            
        }
    }
}
