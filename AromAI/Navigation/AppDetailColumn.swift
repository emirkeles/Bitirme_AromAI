//
//  AppDetailColumn.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

struct AppDetailColumn: View {
    var screen: AppScreen?
    
    var body: some View {
        Group {
            if let screen {
                screen.destination
                    .foregroundStyle(.clear)
            } else {
                ContentUnavailableView("Select something", systemImage: "bird", description: Text("Pick something from the list"))
            }
        }
    }
}
