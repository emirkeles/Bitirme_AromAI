//
//  SigninView.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import SwiftUI

struct SigninView: View {
    @Environment(\.userClient) var userClient
    @Environment(\.errorAlert) var errorAlert
    @Environment(\.dismiss) var dismiss
    @Binding var path: [AuthenticationRoute]
    @FocusState private var focusedField: Field?
    @State private var mail = ""
    @State private var password = ""
    @AppStorage("loggedIn") var loggedIn: Bool?
    
    enum Field: Hashable {
        case mail, password
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                headerImage
                headerText
                signupForm
                signinButton
                dontHaveAccountButton
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarButton
                keyboardToolbarButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - View Components
private extension SigninView {
    var headerImage: some View {
        Image(.photo5)
            .resizable()
            .scaledToFit()
            .frame(height: UIScreen.main.bounds.height * 0.36)
    }
    
    @ViewBuilder
    var headerText: some View {
        Text("Giriş Yap")
            .font(.title2)
            .bold()
        
        Text("Uygulamaya devam etmek için giriş yapın")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    @ViewBuilder
    var signupForm: some View {
        TextField("Email Adresi", text: $mail)
            .setCustomStyle(icon: "envelope")
            .textContentType(.emailAddress)
            .focused($focusedField, equals: .mail)
            .onSubmit {
                focusedField = .password
            }
        TextField("Parola", text: $password)
            .setCustomStyle(icon: "lock")
            .textContentType(.password)
            .focused($focusedField, equals: .password)
            .onSubmit {
                login()
                focusedField = nil
            }
    }
    
    func login() {
        Task {
            do {
                try await userClient.login(with: .init(email: mail, password: password))
                focusedField = nil
                userClient.updateValidation(success: true)
                loggedIn = true
            } catch {
                await errorAlert.present(AromAIError.custom)
            }
        }
    }
    
    var signinButton: some View {
        CustomButton {
            login()
        } content: {
            Text("Giriş Yap")
        }
    }
    
    var dontHaveAccountButton: some View {
        HStack {
            Text("Henüz bir hesabın yok mu?")
                .font(.caption)
            Button(action: {
                if path.contains(.Signup) {
                    path = path.dropLast()
                } else {
                    path.append(.Signup)
                }
            }, label: {
                Text("Hemen Oluştur!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.primaryColor)
            })
        }
        .padding(.top, 5)
    }
    
    var leadingToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {dismiss()}, label: {
                Image(systemName: "arrow.backward.square")
                    .font(.system(size: 20))
            })
            .buttonStyle(.plain)
            
        }
    }
    
    var keyboardToolbarButton: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(action: {
                focusedField = nil
            }, label: {
                Image(systemName: "keyboard.chevron.compact.down")
            })
        }
    }
}

