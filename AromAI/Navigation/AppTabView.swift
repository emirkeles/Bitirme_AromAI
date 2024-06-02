//
//  AppTabView.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

struct AppTabView: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            ZStack {
                HStack(spacing: 20) {
                    ForEach(AppScreen.allCases) { item in
                        Button {
                            selection = item
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: selection == item)
                        }
                    }
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .padding(.top, 2)
            .background(ignoresSafeAreaEdges: .all)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension AppTabView {
    func CustomTabItem(imageName: String, title: LocalizedStringKey, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .white : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
        }
        .frame(width: isActive ? .bottomTabHeight : 50, height: 40)
        .background(isActive ? .primaryColor : .clear)
        .cornerRadius(8)
    }
}
