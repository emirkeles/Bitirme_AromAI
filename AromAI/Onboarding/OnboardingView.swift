//
//  OnboardingView.swift
//  AromAI
//
//  Created by Emir Keleş on 6.03.2024.
//

import SwiftUI

struct OnboardingView: View {
    let slides: [Slide]
    @State private var currentPageIndex = 0
    @AppStorage("onboardCompleted") var onboardCompleted: Bool?
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $currentPageIndex) {
                    ForEach(0..<3) { index in
                        SlideCardView(slide: slides[index]) {
                            if index < slides.count - 1 {
                                withAnimation {
                                    currentPageIndex += 1
                                }
                            } else {
                                onboardCompleted = true
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            
            HStack {
                Button(action: {
                    onboardCompleted = true
                }) {
                    Group {
                        Text("Tanıtımı geç")
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.secondary)
                            .offset(y: 1)
                    }
                    .frame(height: 40, alignment: .center)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            
        }
        .onAppear {
            setupAppearance()
        }
    }
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(red: 234/255, green: 109/255, blue: 109/255, alpha: 1.0)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
    }
}
