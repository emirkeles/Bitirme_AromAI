//
//  SlideCardView.swift
//  AromAI
//
//  Created by Emir Keleş on 6.03.2024.
//

import SwiftUI

struct SlideCardView: View {
    var slide: Slide
    var action: () -> Void
    @State private var isAnimating = false
    var body: some View {
        VStack {
            Image(slide.image)
                .resizable()
                .scaledToFit()
            
            HStack(alignment: .firstTextBaseline) {
                let words = slide.title.split(separator: " ")
                let firstTwo = words.prefix(2).joined(separator: " ")
                let remaining = words.dropFirst(2).joined(separator: " ")
                Text(firstTwo).foregroundStyle(.primaryColor) +
                Text(" \(remaining)")
                    
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
            .frame(maxWidth: 480)
            .font(.largeTitle)
            .fontWeight(.regular)
//            Button(action: action) {
//                Text(slide.buttonText)
//                    .font(.system(size: 17, weight: .medium, design: .default))
//                    .padding()
//                    .foregroundStyle(.white)
//                    .frame(width: 250)
//                    .background(.primaryColor)
//                    .clipShape(.buttonBorder)
//                
//            }
            CustomButton {
                action()
            } content: {
                Text(slide.buttonText)
            }

        }
    }
}

struct CustomButton<Content: View>: View {
    
    let action: () -> Void
    let content: Content
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    var body: some View {
        Button(action: action) {
            content
                .font(.system(size: 17, weight: .medium, design: .default))
                .padding()
                .foregroundStyle(.white)
                .frame(width: 250)
                .background(.primaryColor)
                .clipShape(.buttonBorder)
            
        }
    }
}
