//
//  Diet.swift
//  AromAI
//
//  Created by Emir Keleş on 26.03.2024.
//

import Foundation
import SwiftUI

private struct Diet: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct DietView: View {
    @State private var focusSearch = false
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var dragOffset: CGSize = .zero
    @AppStorage("registrationDetailsCompleted") private var registrationDetailsCompleted: Bool?
    @Binding var navigationPath: [RegistrationStep]
    @State private var diets: [RecipeHealth] = [
    ]
    @State private var selectedDiets: [RecipeHealth] = []
    
    let columns = [
        GridItem(.adaptive(minimum: 100)),
    ]
    @StateObject private var debouncedSearchText = DebouncedState(initialValue: "")
    @Environment(\.userClient) private var userClient
    
    
    var body: some View {
        VStack {
            ScrollView {
                if !focusSearch {
                    headerTitle
                    headerCaption
                }
                CustomSearchBar(text: $debouncedSearchText.currentValue, prompt: "Diyet arayın...")
                    .onChange(of: debouncedSearchText.debouncedValue, { oldValue, newValue in
                        fetchDiets(searchText: newValue == "" ? nil : newValue)
                    })
                    .padding()
                
                LazyVGrid(columns: columns) {
                    ForEach(diets) { diet in
                        DietItemView(diet: diet, isSelected: selectedDiets.contains(diet)) {
                            toggleSelection(for: diet)
                        }
                    }
                }
                .padding()
            }
            .task {
                fetchDiets(searchText: nil)
            }
            Spacer()
            HStack {
                Button(action: {
                    navigationPath.removeLast()
                }, label: {
                    Text("Önceki")
                        .font(.system(size: 17, weight: .medium, design: .default))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.primaryColor)
                        .background(Color(red: 234/255, green: 109/255, blue: 109/255, opacity: 0.25))
                        .clipShape(.buttonBorder)
                })
                Button(action: {
                    userClient.diseases = selectedDiets
                    navigationPath.append(.likedCountry)
                }, label: {
                    Text("Sonraki")
                        .font(.system(size: 17, weight: .medium, design: .default))
                        .padding()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(.primaryColor)
                        .clipShape(.buttonBorder)
                })
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leadingToolbarButton
            trailingToolbarButton
        }
        .gesture(DragGesture().updating($dragOffset, body: { value, state, transaction in
            if (value.startLocation.x < 20 && value.translation.width > 100) {
                dismiss()
            }
        }))
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
    
    private func fetchDiets(searchText: String?) {
        Task {
            do {
                let searchedDiets = try await userClient.getDiseases(searchText: searchText, page: nil, pageSize: 15)
                diets = searchedDiets
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func toggleSelection(for diet: RecipeHealth) {
        if let index = selectedDiets.firstIndex(of: diet) {
            selectedDiets.remove(at: index)
        } else {
            selectedDiets.append(diet)
        }
    }
}

private struct DietItemView: View {
    let diet: RecipeHealth
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(diet.name)
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

private extension DietView {
    var headerTitle: some View {
        Text("Uygulamanız gereken bir diyet veya yeme alışkanlığınız var mı?")
            .font(.system(size: 18))
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top])
    }
    
    var headerCaption: some View {
        Text("Bir rahatsızlığınız varsa veya yemek alışkanlığınız varsa lütfen aşağıdaki bölümden bunları seçiniz")
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
                        .stroke(step == 2 ? .primaryColor : .secondary, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .overlay(Text("\(step)").font(.system(size: 14)).foregroundStyle(step == 2 ? .primaryColor : .secondary))
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
