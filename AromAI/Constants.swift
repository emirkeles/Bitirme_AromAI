//
//  Constants.swift
//  AromAI
//
//  Created by Emir Keleş on 26.05.2024.
//

import Foundation

struct Constants {
    // MARK: - Localized strings for kitchens
    static let europe = NSLocalizedString("Avrupa", comment: "")
    static let asia = NSLocalizedString("Asya", comment: "")
    static let middleEast = NSLocalizedString("Orta Doğu", comment: "")
    static let latinAmerica = NSLocalizedString("Latin Amerika", comment: "")
    static let africa = NSLocalizedString("Afrika", comment: "")
    static let turkish = NSLocalizedString("Türk", comment: "")
    static let mexico = NSLocalizedString("Meksika", comment: "")
    
    // MARK: - Localized strings for allergies
    static let tomato = NSLocalizedString("Domates", comment: "")
    static let apple = NSLocalizedString("Elma", comment: "")
    static let carrot = NSLocalizedString("Havuç", comment: "")
    static let banana = NSLocalizedString("Muz", comment: "")
    static let pear = NSLocalizedString("Armut", comment: "")
    static let lemon = NSLocalizedString("Limon", comment: "")
    static let orange = NSLocalizedString("Portakal", comment: "")
    static let watermelon = NSLocalizedString("Karpuz", comment: "")
    static let strawberry = NSLocalizedString("Çilek", comment: "")
    
    // MARK: - Localized strings for meals
    static let breakfast = NSLocalizedString("Kahvaltı", comment: "")
    static let lunch = NSLocalizedString("Öğle Yemeği", comment: "")
    static let dinner = NSLocalizedString("Akşam Yemeği", comment: "")
    static let snack = NSLocalizedString("Atıştırmalık", comment: "")
    
    static let likedKitchens: [LikedKitchen] = [
        LikedKitchen(name: europe),
        LikedKitchen(name: asia),
        LikedKitchen(name: middleEast),
        LikedKitchen(name: latinAmerica),
        LikedKitchen(name: africa),
        LikedKitchen(name: turkish),
        LikedKitchen(name: mexico)
    ]
    static let allergies: [Allergy] = [
            Allergy(name: tomato),
            Allergy(name: apple),
            Allergy(name: carrot),
            Allergy(name: banana),
            Allergy(name: pear),
            Allergy(name: lemon),
            Allergy(name: orange),
            Allergy(name: watermelon),
            Allergy(name: strawberry)
        ]
    static let meals: [Meal] = [
            Meal(name: breakfast),
            Meal(name: lunch),
            Meal(name: dinner),
            Meal(name: snack)
        ]
    static let aiItems: [AiItem] = [
            .init(
                image: "ai-1",
                title: "Bölgeye Göre",
                content: "Sevdiğiniz mutfakları seçin ve yapay zeka sizin için tarif önersin!",
                navigation: .region
            ),
            .init(
                image: "ai-2",
                title: "Malzemeye Göre",
                content: "Elinizdeki malzemeleri söyleyin, bu malzemeler ile tarif önersin!",
                navigation: .ingredients
            ),
            .init(
                image: "ai-3",
                title: "Öğüne Göre",
                content: "Hangi öğün için yemek yapacağınızı seçmeniz yeterli gerisini yapay zekaya bırakın!",
                navigation: .meal
            ),
            .init(
                image: "ai-4",
                title: "Filtreye Göre",
                content: "Birden çok filtre ile daha özelleştirilmiş tarifler oluşturun!",
                navigation: .filter
            )
    ]
    
    
}
