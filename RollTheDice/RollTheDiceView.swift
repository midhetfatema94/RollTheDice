//
//  RollTheDiceView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import SwiftUI

struct RollTheDiceView: View {
    @State private var outcome = 0
    @EnvironmentObject var results: DiceResults

    var body: some View {
        VStack {
            Text("Result is: \(outcome)")
            
            Button(action: rollDice, label: {
                Text("Roll the dice")
            })
        }
    }
    
    func rollDice() {
        let randomResult = Int.random(in: 1...6)
        outcome = randomResult
        
        let diceResult = Dice()
        diceResult.result = outcome
        results.results.append(diceResult)
    }
}

struct RollTheDiceView_Previews: PreviewProvider {
    static var previews: some View {
        RollTheDiceView()
    }
}
