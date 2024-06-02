//
//  NewRecipeSheet.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI
import PhotosUI

// MARK: - Models
struct RecipeForm: Codable {
    var coverPhotoId: String? = ""
    var title: String = ""
    var description: String = ""
    var preparationTime: String = "0"
    var calories: String = "0"
    var cuisinePreferenceId = ""
    var recipeSteps: [RecipeStep] = []
    var recipeIngredients: [SheetIngredient] = []
}

struct NewRecipeSheet: View {
    @Environment(\.userClient) private var userClient
    @State private var recipeItem: PhotosPickerItem?
    @State private var recipeImage: Image?
    @State private var isPickerPresented = false
    @State private var jpegData: Data?
    @Environment(\.dismiss) private var dismiss
    @State var recipeForm = RecipeForm()
    @State private var selectedIngredient: RecipeIngredient?
    @State private var openSheet = false
    @State private var malzemeler = [NewRecipeIngredient]()
    @Binding var sheetPresentation: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(spacing: 0) {
                    VStack {
                        Text("1")
                            .frame(minWidth: 28, minHeight: 28, alignment: .center)
                            .foregroundStyle(.white)
                            .background(.primaryColor, in: Circle())
                        Text("Temel Bilgiler")
                            .foregroundStyle(.primaryColor)
                            .font(.caption2)
                    }
                    Rectangle().frame(width: 80, height: 1)
                        .offset(x: -4, y: -8)
                    VStack {
                        Text("2")
                            .frame(width: 28, height: 28)
                            .background(.thinMaterial, in: Circle())
                        Text("Aşamalar")
                            .font(.caption2)
                    }
                }
                PhotosPicker(selection: $recipeItem, matching: PHPickerFilter.images) {
                    Group {
                        if let image = recipeImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 340, height: 190)
                                .clipShape(RoundedRectangle(cornerRadius: 6.25))
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        withAnimation(.bouncy) {
                                            recipeImage = nil
                                            recipeItem = nil
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.black, .white)
                                            .font(.title)
                                    }
                                }
                        } else {
                            VStack {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.primaryColor)
                                    .padding(.bottom, 2)
                                Text("Kapak Resmi Yükle")
                                    .font(.system(size: 20, weight: .medium))
                                Text("Yüklediğin kapak resmi diğer kullanıcılar tarafından görülen ilk resim olacak")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal)
                            }
                            
                        }
                    }
                    .frame(width: 350, height: 200)
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3])))
                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .buttonStyle(.plain)
                .padding()
                
                Text("Genel Bilgiler")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .bottom])
                Text("Yemek İsmi")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                TextField("Yemek ismini giriniz...", text: $recipeForm.title)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.thinMaterial)
                    )
                    .padding([.horizontal, .bottom])
                Text("Yemek Açıklaması")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                TextField("Yemek açıklamasını giriniz...", text: $recipeForm.description, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2...4)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.thinMaterial)
                    )
                    .padding([.horizontal, .bottom])
                
                HStack {
                    VStack {
                        Text("Süre (dakika)")
                        TextField("Süre", text: $recipeForm.preparationTime)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 100, height: 50)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 6))
                    }
                    Spacer()
                    VStack {
                        Text("Kalori")
                        TextField("Kalori", text: $recipeForm.calories)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 100, height: 50)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 6))
                    }
                    Spacer()
                    VStack {
                        Text("Bölge")
                        Picker("Bölge", selection: $recipeForm.cuisinePreferenceId) {
                            ForEach(userClient.allCuisines) { cuisine in
                                Text(cuisine.name)
                                    .tag(cuisine.id)
                            }
                        }
                        .frame(width: 120, height: 50)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 6))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                .padding(.horizontal)
                
                HStack {
                    Text("Malzemeler")
                        .font(.headline)
                    Spacer()
                    Button {
                        withAnimation {
                            openSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .font(.system(size: 20, weight: .medium))
                            .padding(6)
                            .background(.primaryColor, in: RoundedRectangle(cornerRadius: 5))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                if malzemeler.count > 0 {
                    ForEach($malzemeler, id: \.self) { $ingredient in
                        HStack {
                            Text(ingredient.name)
                                .font(.headline)
                                .foregroundStyle(.primaryColor)
                            Spacer()
                            HStack {
                                Text("\(ingredient.quantity.formatted())")
                                Text(ingredient.quantityType)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
            }
            .contentMargins(.bottom, 60, for: .scrollIndicators)
            .contentMargins(.bottom, 40)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("İptal")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SecondPage(recipeForm: $recipeForm, sheetPresentation: $sheetPresentation)
                    } label: {
                        
                        Text("İleri")
                            .fontWeight(.semibold)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        loadImage()
                    })
                    
                    
                }
            }
            .navigationTitle("Yeni Tarif Oluştur")
        }
        .onChange(of: recipeItem) {
            Task {
                if let loaded = try? await
                    recipeItem?.loadTransferable(type: Data.self) {
                    withAnimation {
                        let uiImage = UIImage(data: loaded)
                        recipeImage = Image(uiImage: uiImage!)
                        jpegData = loaded
                    }
                    
                }
            }
        }
        .sheet(isPresented: $openSheet) {
            IngredientPicker(ingredients: $malzemeler, recipeForm: $recipeForm)
        }
        .onTapGesture {
            self.dismissKeyboard()
        }
        .task {
            do {
                let searchedAllergies = try await userClient.getIngredients(searchText: nil, page: nil, pageSize: 8)
                userClient.allIngredients = searchedAllergies
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadImage() {
        Task {
            do {
                if let jpegData {
                    let imageResponse = try await userClient.uploadMediaFile(mediaRequest:.init(jpegData: jpegData, mediaName: "Data", fileType: .RecipeImage))
                    recipeForm.coverPhotoId = imageResponse.data.id
                } else {
                    recipeForm.coverPhotoId = nil
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct IngredientPicker: View {
    @Binding var ingredients: [NewRecipeIngredient]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.userClient) private var userClient
    
    @State var newIngredients = [NewIngredient]()
    @StateObject private var debouncedSearchText = DebouncedState(initialValue: "")
    @State var recipeIngredient = [RecipeIngredient]()
    @State var ingredientQuantity = ""
    @State var ingredientQuantityType = ""
    @State var selectedIngredientName = ""
    @State var selectedId = ""
    
    @Binding var recipeForm: RecipeForm
    
    var body: some View {
        NavigationStack {
            List {
                Section("Malzemeler") {
                    ForEach(recipeIngredient, id: \.id) { ingredient in
                        HStack {
                            Button {
                                selectedIngredientName = ingredient.name
                                selectedId = ingredient.id
                            } label: {
                                Text(ingredient.name)
                            }
                            Spacer()
                            if selectedId == ingredient.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.primaryColor)
                            }
                        }
                    }
                }
                
                Section("Miktar") {
                    TextField("Miktar (Örn. 5)", text: $ingredientQuantity)
                        .keyboardType(.numberPad)
                    TextField("Miktar Türü (Örn. Kaşık)", text: $ingredientQuantityType)
                        .keyboardType(.alphabet)
                }
                HStack {
                    Button {
                        
                        ingredients.append(
                            .init(
                                ingredientId: selectedId,
                                name: selectedIngredientName,
                                quantity: Double(ingredientQuantity)!,
                                quantityType: ingredientQuantityType
                            )
                        )
                        recipeForm.recipeIngredients.append(
                            .init(
                                ingredientId: selectedId,
                                quantityType: ingredientQuantityType,
                                quantity: Double(ingredientQuantity)!
                            )
                        )
                        dismiss()
                    } label: {
                        Text("Kaydet")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .task {
                fetchIngredients(searchText: nil)
                newIngredients = userClient.allIngredients.map { convertToNewIngredient($0) }
            }
            .searchable(text: $debouncedSearchText.currentValue)
            .toolbarTitleDisplayMode(.large)
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: debouncedSearchText.debouncedValue) { oldValue, newValue in
                fetchIngredients(searchText: newValue == "" ? nil : newValue)
            }
            .navigationTitle("Malzeme Ekle")
        }
    }
    
    private func fetchIngredients(searchText: String?) {
        Task {
            do {
                let searchedAllergies = try await userClient.getIngredients(searchText: searchText, page: nil, pageSize: 8)
                recipeIngredient = searchedAllergies
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func convertToNewIngredient(_ ingredient: RecipeIngredient) -> NewIngredient {
        return NewIngredient(id: ingredient.id, name: ingredient.name)
    }
}

struct SecondPage: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.userClient) private var userClient
    @State private var tempSteps = [TempSteps]()
    @State private var stepCount = 1
    @State private var selectedStep: TempSteps?
    @Binding var recipeForm: RecipeForm
    @Binding var sheetPresentation: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                HStack(spacing: 0) {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white, .green)
                        Text("Temel Bilgiler")
                            .foregroundStyle(.green)
                            .font(.caption2)
                    }
                    Rectangle().frame(width: 80, height: 1)
                        .offset(x: -4, y: -8)
                    VStack {
                        Text("2")
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                            .background(.primaryColor, in: Circle())
                        Text("Aşamalar")
                            .foregroundStyle(.primaryColor)
                            .font(.caption2)
                    }
                }
                HStack {
                    Text("Yapılış Aşamaları")
                        .font(.headline)
                        .padding(.top)
                    Spacer()
                    Button("+ Ekle") {
                        tempSteps.append(.init(description: "", stepNumber: stepCount))
                        stepCount += 1
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.primaryColor)
                }
                .padding(.horizontal)
                HStack {
                    ForEach(tempSteps.indices, id: \.self) { index in
                        Button {
                            withAnimation() {
                                selectedStep = tempSteps[index]
                            }
                        } label: {
                            let step = NSLocalizedString("Adım", comment: "")
                            Text("\(selectedStep?.stepNumber == tempSteps[index].stepNumber ? step : "") \(tempSteps[index].stepNumber)")
                                .padding(.horizontal, 4)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(selectedStep?.stepNumber == tempSteps[index].stepNumber ? .white : .black)
                                .frame(minWidth: 30, idealWidth: 50, minHeight: 30)
                                .background(
                                    (selectedStep?.stepNumber == tempSteps[index].stepNumber ? .primaryColor :
                                        Color(red: 244/255, green: 244/255, blue: 244/255)), in: RoundedRectangle(cornerRadius: 4))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                if let selectedStep {
                    TextField("Yemek açıklamasını giriniz...", text:$tempSteps[tempSteps.firstIndex(where: { $0.id == selectedStep.id })!].description, axis: .vertical)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4...6)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(.thinMaterial)
                        )
                        .padding([.horizontal, .bottom])
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                            Text("Geri")
                            
                        }
                        
                    }
                }
            }
            .navigationTitle("Yeni Tarif Oluştur")
            .navigationBarBackButtonHidden(true)
            
            CustomButton(action: {
                Task {
                    var recipeSteps = [RecipeStep]()
                    for index in 0..<tempSteps.count {
                        let newStep = RecipeStep(description: tempSteps[index].description, stepNumber: tempSteps[index].stepNumber)
                        recipeSteps.append(newStep)
                    }
                    recipeForm.recipeSteps = recipeSteps
                    
                    do {
                        let requestForm = RecipeCreationRequest(
                            coverPhotoId: recipeForm.coverPhotoId,
                            title: recipeForm.title,
                            description: recipeForm.description,
                            preparationTime: Double(recipeForm.preparationTime) ?? 0,
                            calories: Double(recipeForm.calories) ?? 0,
                            cuisinePreferenceId: recipeForm.cuisinePreferenceId,
                            recipeSteps: recipeForm.recipeSteps,
                            recipeIngredients: recipeForm.recipeIngredients
                        )
                        try await userClient.createRecipe(recipe: requestForm)
                        sheetPresentation = false
                    } catch {
                        sheetPresentation = false
                        print(error.localizedDescription)
                    }
                }
            }) {
                Text("Tarif Oluştur")
            }
            .frame(height: 60, alignment: .top)
        }
    }
}
