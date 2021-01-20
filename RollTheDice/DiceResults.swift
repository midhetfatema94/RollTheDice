//
//  DiceResults.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import Foundation

class Dice: Codable, Identifiable {
    var id = UUID()
    var result = 0
}

class DiceResults: ObservableObject {
    @Published var results: [Dice]
    
    init() {
            
        self.results = []
        
//        if let data = UserDefaults.standard.data(forKey: Self.userDefaultKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                self.people = decoded
//            }
//        }
    }
    
    private func save() {
//        if let encoded = try? JSONEncoder().encode(self.results) {
            
//        }
    }
}
