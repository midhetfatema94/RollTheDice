//
//  DiceResults.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import Foundation
import SwiftUI

class Dice: Identifiable {
    var id = UUID()
    var result = 0
    var faces = 6
}

class DiceSettings {
    var faces = 6
    var haptics = true
}

class DiceResults: ObservableObject {
    @Published private(set) var results: [Dice]
    @Published private(set) var diceSettings = DiceSettings()
    
    init() {
        self.results = []
    }
    
    func loadData(diceResults: FetchedResults<DiceResult>) {
        self.results = diceResults.map {result in
            let newItem = Dice()
            newItem.id = result.id ?? UUID()
            newItem.result = Int(result.result)
            newItem.faces = Int(result.faces)
            return newItem
        }
    }
    
    func loadSettingsData(settings: FetchedResults<Settings>) {
        if let mySettings = settings.last {
            self.diceSettings.faces = Int(mySettings.currentFaces)
            self.diceSettings.haptics = mySettings.hapticControl
        }
    }
    
    func addItem(_ newItem: Dice) {
        self.results.append(newItem)
    }
    
    func updateSettings(haptics: Bool, faces: Int) {
        self.diceSettings.faces = Int(faces)
        self.diceSettings.haptics = haptics
    }
}
