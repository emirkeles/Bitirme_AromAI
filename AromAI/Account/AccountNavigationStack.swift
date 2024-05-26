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
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Image(.efsanevi)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    Text("Mustafa Turgut")
                        .font(.headline)
                    Text("mustafa.turgut3460@gmail.com")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                NavigationLink {
                    Text("Profil Ayarlarım")
                } label: {
                    Label("Profil Ayarlarım", systemImage: "person")
                }
                Button(action: {
                    userClient.logout()
                    loggedIn = false
                    registrationDetailsCompleted = false
                    onboardCompleted = false
                },
                       label: {
                    Label("Çıkış Yap", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.red)
                })
            }
            .navigationTitle("Hesabım")
        }
        
        
    }
}


