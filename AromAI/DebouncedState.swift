//
//  DebouncedState.swift
//  AromAI
//
//  Created by Emir Keleş on 28.05.2024.
//

import Foundation

final class DebouncedState<Value>: ObservableObject {
    @Published var currentValue: Value
    @Published var debouncedValue: Value
    
    init(initialValue: Value, delay: Double = 0.3) {
        _currentValue = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        $currentValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}
