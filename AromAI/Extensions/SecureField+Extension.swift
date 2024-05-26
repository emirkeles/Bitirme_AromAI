//
//  SecureField+Extension.swift
//  AromAI
//
//  Created by Emir Keleş on 28.03.2024.
//

import Foundation
import SwiftUI

struct CustomSecureFieldModifier: ViewModifier {
    var icon: String
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .font(.title3)
                .frame(width: 30)
                .padding(.leading)
            content
                .padding(.vertical)
        }
        .background(.quinary)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.vertical, 2)
        
    }
}

extension SecureField {
    func setCustomStyle(icon: String) -> some View {
        modifier(CustomSecureFieldModifier(icon: icon))
    }
}
