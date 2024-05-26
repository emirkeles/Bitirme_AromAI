//
//  CapsulePicker.swift
//  AromAI
//
//  Created by Emir Keleş on 2.05.2024.
//

import SwiftUI

struct CapsulePicker: View {
    @Binding var selectedIndex: Int
    @State private var hoverIndex = 0
    @State private var dragOffset: CGFloat = 0
    @State private var optionWidth: CGFloat = 0
    @State private var totalSize: CGSize = .zero
    @State private var isDragging: Bool = false
    let titles: [String]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(.primaryColor)
                .padding(isDragging ? 2 : 0)
                .frame(width: optionWidth, height: totalSize.height)
                .offset(x: dragOffset)
                .gesture(
                    LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .onChanged { value in
                            switch value {
                            case .first(true):
                                isDragging = true
                            case .second(true, let drag):
                                let translationWidth = (drag?.translation.width ?? 0) + CGFloat(selectedIndex) * optionWidth
                                hoverIndex = Int(round(min(max(0, translationWidth), optionWidth * CGFloat(titles.count - 1)) / optionWidth))
                            default:
                                isDragging = false
                            }
                        }
                        .onEnded { value in
                            if case .second(true, let drag?) = value {
                                let predictedEndOffset = drag.translation.width + CGFloat(selectedIndex) * optionWidth
                                selectedIndex = Int(round(min(max(0, predictedEndOffset), optionWidth * CGFloat(titles.count - 1)) / optionWidth))
                                hoverIndex = selectedIndex
                            }
                            isDragging = false
                        }
                        .simultaneously(with: TapGesture().onEnded { _ in isDragging = false })
                )
            
                .animation(.spring(), value: dragOffset)
                .animation(.spring(), value: isDragging)
            
            Capsule().fill(.primaryColor).opacity(0.2)
                .padding(-3)
            
            HStack(spacing: 0) {
                ForEach(titles.indices, id: \.self) { index in
                    Text(titles[index])
                        .frame(width: optionWidth, height: totalSize.height, alignment: .center)
                        .foregroundColor(hoverIndex == index ? .white : .secondary)
                        .animation(.easeInOut, value: hoverIndex)
                        .font(.system(size: 14, weight: .bold))
                    
                        .contentShape(Capsule())
                        .onTapGesture {
                            selectedIndex = index
                            hoverIndex = index
                        }.allowsHitTesting(selectedIndex != index)
                }
            }
            .onChange(of: hoverIndex) {_, i in
                dragOffset =  CGFloat(i) * optionWidth
            }
            .onChange(of: selectedIndex) {_, i in
                hoverIndex = i
            }
            .frame(width: totalSize.width, alignment: .leading)
        }
        .background(GeometryReader { proxy in Color.clear.onAppear { totalSize = proxy.size } })
        .onChange(of: totalSize) { optionWidth = totalSize.width/CGFloat(titles.count) }
        .onAppear { hoverIndex = selectedIndex }
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
}
