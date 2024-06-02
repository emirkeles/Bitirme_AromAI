//
//  CustomSearchbar.swift
//  AromAI
//
//  Created by Emir Keleş on 27.03.2024.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var prompt: LocalizedStringKey
    @State private var showCancelButton = false
    @State private var isTextEmpty = true
    @State private var offset: CGFloat = 0
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.tertiary)
                    TextField("", text: $text, prompt: Text(prompt).foregroundStyle(.secondary))
                        
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(isTextEmpty ? 0 : 1)
                    }
                }
                .cornerRadius(5)
                .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                .foregroundStyle(.secondary)
                .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.ultraThickMaterial)
                
                )
                
                if showCancelButton {
                    Button("Cancel") {
                        self.text = ""
                        withAnimation {
                            showCancelButton = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                    .padding(.leading, 10)
                    .transition(.identity)
                }
            }
            .onChange(of: text, { oldValue, newValue in
                withAnimation {
                    isTextEmpty = newValue.isEmpty
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                withAnimation {
                    showCancelButton = true
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                withAnimation {
                    showCancelButton = false
                }
            })
        }
    }
}
