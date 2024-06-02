//
//  Diet.swift
//  AromAI
//
//  Created by Emir Keleş on 26.03.2024.
//

import Foundation
import SwiftUI



struct LikedKitchen: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct LikedKitchenView: View {
    @State var showAlert = false
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset: CGSize = .zero
    @State private var focusSearch = false
    @AppStorage("registrationDetailsCompleted") var registrationDetailsCompleted: Bool?
    @State private var likedKitchens: [RecipeCuisine] = []
    @State private var selectedCountries: [RecipeCuisine] = []
    @StateObject private var debouncedSearchText = DebouncedState(initialValue: "")
    @Environment(\.userClient) private var userClient
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
                CustomSearchBar(text: $debouncedSearchText.currentValue, prompt: "Mutfak arayın...")
                    .onChange(of: debouncedSearchText.debouncedValue, { oldValue, newValue in
                        fetchKitchens(searchText: newValue == "" ? nil : newValue)
                    })
                    .padding()
                
                LazyVGrid(columns: columns) {
                    ForEach(likedKitchens) { kitchen in
                        KitchenItemView(kitchen: kitchen, isSelected: selectedCountries.contains(kitchen)) {
                            toggleSelection(for: kitchen)
                        }
                    }
                }
                .padding()
            }
            .task {
                fetchKitchens(searchText: nil)
            }
            Spacer()
            Button(action: {
                Task {
                    userClient.cuisines = selectedCountries
                    do {
                        try await userClient.addPersonalInfo(person: .init(ingredients: userClient.ingredientsIds, cuisines: userClient.cuisinesIds, healths: userClient.diseasesIds))
                    } catch {
                        print(error.localizedDescription)
                    }
                    registrationDetailsCompleted = true
                }
            }, label: {
                Text("Tamamla")
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(.primaryColor)
                    .clipShape(.buttonBorder)
            })
            .padding()
        }
        .gesture(DragGesture().updating($dragOffset, body: { value, state, transaction in
            if (value.startLocation.x < 20 && value.translation.width > 100) {
                dismiss()
            }
        }))
        .navigationBarBackButtonHidden(true)
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
    
    private func fetchKitchens(searchText: String?) {
        Task {
            do {
                let searchedKitchens = try await userClient.getCuisines(searchText: searchText, page: nil, pageSize: 15)
                likedKitchens = searchedKitchens
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func toggleSelection(for kitchen: RecipeCuisine) {
            if let index = selectedCountries.firstIndex(of: kitchen) {
                selectedCountries.remove(at: index)
            } else {
                selectedCountries.append(kitchen)
            }
        }
}

private extension LikedKitchenView {
    var headerTitle: some View {
        Text("Sevdiğiniz ülke mutfakları nelerdir?")
            .font(.system(size: 18))
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
        
    }
    
    var headerCaption: some View {
        Text("İşaretlediğiniz mutfaklara göre öneriler alacaksınız, lütfen aşağıdaki bölümlerden sevdiğiniz mutfakları seçiniz.")
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
                        .stroke(step == 3 ? .primaryColor : .secondary, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .overlay(Text("\(step)").font(.system(size: 14)).foregroundStyle(step == 3 ? .primaryColor : .secondary))
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
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.primaryColor)
            })
        }
    }
}

private struct KitchenItemView: View {
    let kitchen: RecipeCuisine
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(LocalizedStringKey(kitchen.name))
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
