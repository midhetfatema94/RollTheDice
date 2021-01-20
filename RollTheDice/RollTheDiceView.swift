//
//  RollTheDiceView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import SwiftUI

struct RollTheDiceView: View {
    @State private var outcome = 0
    @State private var showingTransition = false
    @State private var oldDegree: Double = 0
    @State private var newDegree: Double = 180
    @State private var shouldRandomize = false
    @State private var shouldAnimate = false
    @EnvironmentObject var results: DiceResults
    
    let randomizeTimer = Timer.publish(every: 0.1, on: .main, in: .common)
    let animationTimer = Timer.publish(every: 5, on: .main, in: .common)
    
    var body: some View {
        VStack(spacing: 50) {
            if showingTransition {
                Image("dices")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .transition(.pivot(oldDegree: self.oldDegree, newDegree: self.newDegree))
            } else {
                Image("dices")
                    .resizable()
                    .frame(width: 250, height: 250)
            }
            
            Text("Result is: \(outcome)")
                .font(.title)
                .fontWeight(.bold)
            
            Button(action: startRollDice, label: {
                Text("Roll the dice")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
            })
            .background(Color.black)
            .clipShape(Capsule())
        }
        .onReceive(randomizeTimer, perform: {_ in
            
            guard self.shouldRandomize else { return }
            
            let randomResult = Int.random(in: 1...results.faces)
            outcome = randomResult
        })
        .onReceive(animationTimer, perform: {_ in
            
            guard self.shouldAnimate else { return }
            
            self.shouldRandomize = false
            self.completeRolling()
        })
    }
    
    func startRollDice() {
        shouldRandomize = true
        shouldAnimate = true
        let _ = randomizeTimer.connect()
        let _ = animationTimer.connect()
    }
    
    func completeRolling() {
        let randomResult = Int.random(in: 1...results.faces)
        
        shouldAnimate = false
        
        startRotation {
            outcome = randomResult
            
            let diceResult = Dice()
            diceResult.result = outcome
            diceResult.faces = results.faces
            results.results.append(diceResult)
        }
    }
    
    func startRotation(completion: (() -> Void)?) {
        withAnimation {
            self.showingTransition.toggle()
            oldDegree = newDegree
            newDegree += 180
        }
        completion?()
    }
}

struct RollTheDiceView_Previews: PreviewProvider {
    static var previews: some View {
        RollTheDiceView()
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: .center)
    }
}

extension AnyTransition {
    static func pivot(oldDegree: Double, newDegree: Double) -> AnyTransition {
        .modifier(
            active:
                CornerRotateModifier(amount: newDegree),
            identity:
                CornerRotateModifier(amount: oldDegree)
        )
    }
}

