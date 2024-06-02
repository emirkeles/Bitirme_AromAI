//
//  SignupView.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import SwiftUI

struct SignupView: View {
    enum Field: Hashable {
        case name, mail, password, passwordAgain
    }
    @Environment(\.dismiss) var dismiss
    @Environment(\.userClient) var userClient
    @Binding var path: [AuthenticationRoute]
    @FocusState private var focusedField: Field?
    @Environment(\.errorAlert) var errorAlert
    
    @State private var nameSurname = ""
    @State private var mail = ""
    @State private var password = ""
    @State private var passwordAgain = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                headerImage
                headerText
                signupForm
                signupButton
                    .padding(.top, 10)
                switchToSignin
            }
            .offset(y: -60)
            .padding(.horizontal, 30)
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarButton
                keyboardToolbarButton
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension SignupView {
    var headerImage: some View {
        Image(.photo5)
            .resizable()
            .scaledToFit()
            .frame(height: UIScreen.main.bounds.height * 0.36)
    }
    
    @ViewBuilder
    var headerText: some View {
        Text("Kayıt Ol")
            .font(.title2)
            .bold()
        
        Text("Uygulamaya devam etmek için kayıt olun")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    var signupForm: some View {
        VStack(alignment: .leading) {
            Group {
                TextField("Ad Soyad", text: $nameSurname)
                    .setCustomStyle(icon: "person")
                    .textContentType(.name)
                    .focused($focusedField, equals: .name)
                    .onSubmit {
                        focusedField = .mail
                    }
                TextField("Email Adresi", text: $mail)
                    .setCustomStyle(icon: "envelope")
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .focused($focusedField, equals: .mail)
                    .onSubmit {
                        focusedField = .password
                    }
                SecureField("Parola", text: $password)
                    .setCustomStyle(icon: "lock")
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = .passwordAgain
                    }
                SecureField("Parola Tekrar", text: $passwordAgain)
                    .setCustomStyle(icon: "lock")
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .passwordAgain)
            }
        }
    }
    
    var signupButton: some View {
        CustomButton {
            Task {
                do {
                    try await userClient.register(
                        with: .init(
                            name: "Emir",
                            surname: "Keles",
                            email: mail,
                            userName: "P@ssw0rd",
                            password: "P@ssw0rd"
                        )
                    )
                    nameSurname = ""
                    mail = ""
                    password = ""
                    passwordAgain = ""
                    await errorAlert.present(AromAIError.success("Hesabınızı aktifleştirmek için e-posta adresinize gönderilen linke tıklayın."), title: "Kayıt olma başarılı")
                    if path.contains(.Signin) {
                        path = path.dropLast()
                    } else {
                        path.append(.Signin)
                    }
                } catch {
                    await errorAlert.present(error)
                }
            }

        } content: {
            Text("Kayıt Ol")
        }
    }
    
    var switchToSignin: some View {
        HStack {
            Text("Zaten bir hesabın var mı?")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Button(action: {
                withAnimation {
                    if path.contains(.Signin) {
                        path = path.dropLast()
                    } else {
                        path.append(.Signin)
                    }
                }
                
            }, label: {
                Text("Hemen Giriş Yap!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.primaryColor)
            })
        }
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
