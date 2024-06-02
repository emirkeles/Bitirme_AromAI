//
//  InfoCard.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI

struct InfoCard: View {
    var title: LocalizedStringKey
    var value: LocalizedStringKey
    var icon: String
    
    var body: some View {
            VStack(spacing: 14) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(.primaryColor)
                        .font(.caption)
                    Text(value)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.primaryColor)
                }
            }
            .frame(width: 84)
            .padding()
            .background(Color.primaryBackground)
            .cornerRadius(12)

    }
}
