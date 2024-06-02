//
//  Diet.swift
//  AromAI
//
//  Created by Emir Keleş on 26.03.2024.
//

import Foundation
import SwiftUI

struct Allergy: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct AllergyView: View {
    @State var showAlert = false
    @Binding var navigationPath: [RegistrationStep]
    @State private var focusSearch = false
    @AppStorage("registrationDetailsCompleted") var registrationDetailsCompleted: Bool?
    @State private var allergies = [RecipeIngredient]()
    @State private var selectedAllergies = [RecipeIngredient]()
    @Environment(\.userClient) private var userClient
    @StateObject private var debouncedSearchText = DebouncedState(initialValue: "")
    let columns = [
        GridItem(.adaptive(minimum: 100)),
    ]
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                if !focusSearch {
                    headerTitle
                    headerCaption
                }
                CustomSearchBar(text: $debouncedSearchText.currentValue, prompt: "Malzeme arayın...")
                    .onChange(of: debouncedSearchText.debouncedValue, { oldValue, newValue in
                        fetchAllergies(searchText: newValue == "" ? nil : newValue)
                    })
                    .padding()
                
                LazyVGrid(columns: columns) {
                    ForEach(allergies) { allergy in
                        AllergyItemView(allergy: allergy, isSelected: selectedAllergies.contains(allergy)) {
                            toggleSelection(for: allergy)
                        }
                    }
                }
                .padding()
            }
            Spacer()
            Button(action: {
                userClient.ingredients = selectedAllergies
                navigationPath.append(.diet)
            }, label: {
                Text("Sonraki")
                    .font(.system(size: 17, weight: .medium, design: .default))
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(.primaryColor)
                    .clipShape(.buttonBorder)
            })
            .padding()
        }
        .task {
            fetchAllergies(searchText: nil)
        }
        .toolbar {
            leadingToolbarButton
            trailingToolbarButton
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
            withAnimation {
                focusSearch = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
            withAnimation {
                focusSearch = false
            }
        })
    }
    
    private func fetchAllergies(searchText: String?) {
        Task {
            do {
                let searchedAllergies = try await userClient.getIngredients(searchText: searchText, page: nil, pageSize: 15)
                allergies = searchedAllergies
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func toggleSelection(for allergy: RecipeIngredient) {
        if let index = selectedAllergies.firstIndex(of: allergy) {
            selectedAllergies.remove(at: index)
        } else {
            selectedAllergies.append(allergy)
        }
    }
    
}

private extension AllergyView {
    var headerTitle: some View {
        Text("Herhangi bir malzemeye veya ürüne alerjiniz var mı?")
            .font(.system(size: 18))
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
    }
    
    var headerCaption: some View {
        Text("Yediğinizde size zarar verebilecek malzemeleri olabildiğince sizden uzak tutmaya çalışıyoruz. Lütfen aşağıdaki bölümden alerjiniz olan malzemeleri seçiniz.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)
            .padding(.leading)
    }
    
    var leadingToolbarButton: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            HStack {
                ForEach(1...3, id: \.self) { step in
                    Circle()
                        .stroke(step == 1 ? .primaryColor : .secondary, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .overlay(Text("\(step)").font(.system(size: 14)).foregroundStyle(step == 1 ? .primaryColor : .secondary))
                }
            }
        }
    }
    
    var trailingToolbarButton: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: {
                registrationDetailsCompleted = true
            }, label: {
                Text("Adımı Geç")
                    .foregroundStyle(.primaryColor)
                    .font(.system(size: 17, weight: .medium))
            })
        }
    }
}

private struct AllergyItemView: View {
    let allergy: RecipeIngredient
    let isSelected: Bool
    let onTap: () -> Void
    var dietview = DietView(navigationPath: .constant([.allergy]))
    
    var body: some View {
        Text(allergy.name)
            .font(.caption)
            .minimumScaleFactor(0.8)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                Capsule().fill(isSelected ? .primaryColor.opacity(0.1) : .clear)
                    .stroke(isSelected ? .primaryColor : .secondaryTextColor, lineWidth: 1)
            )
            .onTapGesture(perform: onTap)
            .padding(.vertical, 4)
    }
    
}
