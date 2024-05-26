//
//  Authentication.swift
//  AromAI
//
//  Created by Emir Keleş on 10.03.2024.
//

import SwiftUI

@Observable
class Authentication {
    
    var isValidated = false
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
}
