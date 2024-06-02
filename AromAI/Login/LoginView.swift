//
//  LoginView.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import SwiftUI

enum AuthenticationRoute: Hashable, Identifiable {
    var id: Self { return self }
    
    case Signin
    case Signup
}

struct LoginView: View {
    @Environment(\.userClient) var userClient
    @State private var navigationPath: [AuthenticationRoute] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Image(.photo4)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Group {
                    Text("Kendi evinin şefi olmaya hazır mısın?").font(.title)
                    Text("Yeni lezzetlere adım atmak için kayıt ol veya hesabın varsa giriş yap!").foregroundStyle(.secondary).font(.footnote)
                }
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                
                CustomButton(action: {navigationPath.append(.Signup)}) {
                    Text("Kayıt Ol")
                }
                .padding(.top, 80)
                
                Button {
                    navigationPath.append(.Signin)
                } label: {
                    Text("Giriş Yap")
                        .font(.system(size: 17, weight: .medium, design: .default))
                        .padding()
                        .foregroundStyle(.primaryColor)
                        .frame(width: 250)
                        .background(Color(red: 234/255, green: 109/255, blue: 109/255, opacity: 0.25))
                        .clipShape(.buttonBorder)
                }
            }
            .navigationDestination(for: AuthenticationRoute.self) { route in
                switch route {
                case .Signin:
                    SigninView(path: $navigationPath)
                case .Signup:
                    SignupView(path: $navigationPath)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
