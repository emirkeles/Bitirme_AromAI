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
    var title: LocalizedStringKey
    var content: LocalizedStringKey
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
    
    private let items: [AiItem] = Constants.aiItems
    
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
            .padding([.horizontal, .top])
            .padding(.top)
        Text("Aşağıdaki seçenekler ile yapay zeka aracınızı kullanarak yeni tarifler oluşturun!")
            .font(.footnote)
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
            .foregroundStyle(.thickMaterial)
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

#Preview {
    AppTabView(selection: .constant(.ai))
        .preferredColorScheme(.dark)
}

#Preview {
    AppTabView(selection: .constant(.ai))
        .preferredColorScheme(.light)
}
