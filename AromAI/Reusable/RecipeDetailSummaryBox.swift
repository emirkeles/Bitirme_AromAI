//
//  RecipeDetailSummaryBox.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI

struct RecipeDetailSummaryBox: View {
    var interval: String
    var calory: String
    var region: String
    var body: some View {
        HStack(spacing: 12) {
            InfoCard(title: "Süre", value: "\(interval) dk", icon: "clock")
            InfoCard(title: "Kalori", value: "\(calory)", icon: "flame")
            InfoCard(title: "Bölge", value: "\(region)", icon: "globe")
        }
        .padding()
    }
}

struct AIRecipeDetailSummaryBox: View {
    var interval: String
    var calory: String
    var body: some View {
        HStack(spacing: 12) {
            InfoCard(title: "Süre", value: "\(interval) dk", icon: "clock")
            InfoCard(title: "Kalori", value: "\(calory)", icon: "flame")
        }
        .padding()
    }
}
