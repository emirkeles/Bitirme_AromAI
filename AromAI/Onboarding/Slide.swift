//
//  SlideData.swift
//  AromAI
//
//  Created by Emir Keleş on 6.03.2024.
//

import Foundation
import SwiftUI

struct Slide: Identifiable {
    var id = UUID()
    var title: LocalizedStringKey
    var image: String
    var buttonText: LocalizedStringKey
    
}

let slideData: [Slide] = [
    .init(title: "Yeni yemekler ve insanlar keşfet, kendini yemek dünyasında geliştir!", image: "photo-1", buttonText: "Sonraki"),
    .init(title: "Elindeki yemekleri ziyan etme, asistanına sor ve yeni lezzetler üret!", image: "photo-2", buttonText: "Sonraki"),
    .init(title: "Kendi tariflerini paylaş ve diğer kullanıcılar ile etkileşime gir!", image: "photo-3", buttonText: "Hadi Başlayalım!")
]
