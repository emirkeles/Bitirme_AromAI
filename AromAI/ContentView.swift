//
//  ContentView.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: AppScreen? = .recipes
    var body: some View {
        AppTabView(selection: $selection)
    }
}
