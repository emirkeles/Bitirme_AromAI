//
//  Color+Extension.swift
//  AromAI
//
//  Created by Emir Keleş on 5.03.2024.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var primaryColor: Color { Color(red: 234/255, green: 109/255, blue: 109/255) }
    
    static var primaryBackground: Color { Color(red: 234/255, green: 109/255, blue: 109/255, opacity: 0.15)}
    
    static var primaryDark: Color { Color(red: 190/255, green: 88/255, blue: 88/255) }
    
    static var primaryLight: Color { Color(red: 240/255, green: 153/255, blue: 153/255) }
    
    static var secondaryColor: Color { Color(red: 252/255, green: 227/255, blue: 138/255) }
    
    static var tertiaryColor: Color { Color(red: 234/255, green: 255/255, blue: 208/255) }
    
    static var quaternaryColor: Color { Color(red: 149/255, green: 225/255, blue: 211/255) }
    
    static var danger: Color { Color(red: 220/255, green: 53/255, blue: 69/255) }
    
    static var dangerBackground: Color { Color(red: 220/255, green: 53/255, blue: 69/255, opacity: 0.15) }
    
    static var info: Color { Color(red: 13/255, green: 202/255, blue: 240/255) }
    
    static var infoBackground: Color { Color(red: 13/255, green: 202/255, blue: 240/255, opacity: 0.15) }
    
    static var warning: Color { Color(red: 255/255, green: 193/255, blue: 7/255) }
    
    static var warningBackground: Color { Color(red: 255/255, green: 193/255, blue: 7/255, opacity: 0.15) }
    
    static var success: Color { Color(red: 0, green: 152/255, blue: 121/255) }
    
    static var successBackground: Color { Color(red: 0, green: 152/255, blue: 121/255, opacity: 0.15) }
    
    static var secondaryTextColor: Color { Color(red: 157/255, green: 157/255, blue: 157/255, opacity: 1) }
    
    
}
