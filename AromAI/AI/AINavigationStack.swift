//
//  AINavigationStack.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

struct AiItem: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var content: String
    var navigation: AiNavigation
}

struct Meal: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

enum AiNavigation: Hashable {
    case region, ingredients, meal, filter
}

struct AINavigationStack: View {
    
    private let items: [AiItem] = [
        .init(
            image: "ai-1",
            title: "Bölgeye Göre",
            content: "Sevdiğiniz mutfakları seçin ve yapay zeka sizin için tarif önersin!",
            navigation: .region
        ),
        .init(
            image: "ai-2",
            title: "Malzemeye göre",
            content: "Elinizdeki malzemeleri söyleyin, bu malzemeler ile tarif önersin!",
            navigation: .ingredients
        ),
        .init(
            image: "ai-3",
            title: "Öğüne Göre",
            content: "Hangi öğün için yemek yapacağınızı seçmeniz yeterli gerisini yapay zekaya bırakın!",
            navigation: .meal
        ),
        .init(
            image: "ai-4",
            title: "Filtreye Göre",
            content: "Birden çok filtre ile daha özelleştirilmiş tarifler oluşturun!",
            navigation: .filter
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                headerTitle
                itemGrid
            }
            .navigationDestination(for: AiNavigation.self, destination: AiNavigationDestination)
        }
    }
}

private extension AINavigationStack {
    @ViewBuilder
    var headerTitle: some View {
        Text("Yapay Zeka ile Tarif Oluşturun")
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        Text("Aşağıdaki seçenekler ile yapay zeka aracınızı kullanarak yeni tarifler oluşturun!")
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 100)
            .padding(.top, 1)
            .padding(.horizontal)
    }
    
    var itemGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())]) {
            ForEach(items) { item in
                NavigationLink(value: item.navigation) {
                    AiItemView(item: item)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func AiNavigationDestination(for navigation: AiNavigation) -> some View {
        switch navigation {
        case .region:
            RegionView()
        case .ingredients:
            IngredientsView()
        case .meal:
            MealView()
        case .filter:
            FilterView()
        }
    }
}

struct AiItemView: View {
    let item: AiItem
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 180)
            .foregroundColor(Color(red: 245/255, green: 245/255, blue: 245/255))
            .shadow(color: Color(red: 138/255, green: 138/255, blue: 138/255, opacity: 0.25), radius: 6, y: 8)
            .overlay(
                VStack {
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                    Text(item.title)
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                    Text(item.content)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
            )
            .padding(.vertical, 10)
        
    }
}
