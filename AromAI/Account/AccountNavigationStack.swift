//
//  AccountNavigationStack.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

struct AccountNavigationStack: View {
    @Environment(\.userClient) var userClient
    @AppStorage("loggedIn") var loggedIn: Bool?
    @AppStorage("registrationDetailsCompleted") var registrationDetailsCompleted: Bool?
    @AppStorage("onboardCompleted") var onboardCompleted: Bool?
    @AppStorage("language") var language: String = Locale.current.identifier
    @AppStorage("name") var name: String?
    @AppStorage("email") var email: String?
    @State var useMyInfo: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .foregroundStyle(.primaryColor)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    Text(name ?? "")
                        .font(.headline)
                    Text(email ?? "")
                        .textSelection(.enabled)
                        .foregroundStyle(.blue)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                NavigationLink {
                    userInfo
                } label: {
                    Label("Bilgilerimi gör", systemImage: "person.text.rectangle.fill")
                        .contentTransition(.symbolEffect)
                }
                Toggle("Bilgilerimi Kullan", systemImage: "person.text.rectangle", isOn: $useMyInfo)
                    .contentTransition(.symbolEffect)
                    .onChange(of: useMyInfo) { _, newValue in
                        userClient.useMyInfo = newValue
                    }
                Picker(selection: $language) {
                    Text("Türkçe").tag("tr-TR")
                    Text("English").tag("en-US")
                } label: {
                    Label("Language", systemImage: "globe")
                        .contentTransition(.symbolEffect)
                }
                Button(action: {
                    userClient.logout()
                    loggedIn = false
                    registrationDetailsCompleted = false
                    onboardCompleted = false
                },
                       label: {
                    Label("Çıkış Yap", systemImage: "rectangle.portrait.and.arrow.right")
                        .contentTransition(.symbolEffect)
                        .foregroundStyle(.red)
                })
            }
            .animation(.easeInOut(duration: 0.5), value: language)
            .navigationTitle("Hesabım")
        }
    }
}

extension AccountNavigationStack {
    var userInfo: some View {
        Form {
            Section("Hastalıklar") {
                ForEach(userClient.diseasesNames, id: \.self) { disease in
                    Text(disease)
                }
            }
            Section("Alerji ürünleri") {
                ForEach(userClient.ingredientsNames, id: \.self) { ingredient in
                    Text(ingredient)
                }
            }
            Section("Favori Mutfaklar") {
                ForEach(userClient.cuisines, id: \.self) { cuisine in
                    Text(cuisine.name)
                }
            }
        }
        .contentMargins(.bottom, .bottomTabHeight)
        .navigationTitle("Bilgilerim")
    }
}
