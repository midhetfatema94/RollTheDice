//
//  RollTheDiceView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import SwiftUI
import CoreHaptics
import GameplayKit

struct RollTheDiceView: View {
    @State private var outcome = 0
    @State private var showingTransition = false
    @State private var oldDegree: Double = 0
    @State private var newDegree: Double = 180
    @State private var shouldRandomize = false
    @State private var shouldAnimate = false
    
    @EnvironmentObject var results: DiceResults
    
    @State private var engine: CHHapticEngine?
    
    let randomizeTimer = Timer.publish(every: 0.1, on: .main, in: .common)
    let animationTimer = Timer.publish(every: 5, on: .main, in: .common)
    
    var body: some View {
        VStack(spacing: 50) {
            if showingTransition {
                DiceImageView()
                    .transition(.pivot(oldDegree: self.oldDegree, newDegree: self.newDegree))
            } else {
                DiceImageView()
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
            
            let dice = GKRandomDistribution(lowestValue: 1, highestValue: results.faces)
            outcome = dice.nextInt()
        })
        .onReceive(animationTimer, perform: {_ in
            
            guard self.shouldAnimate else { return }
            
            self.shouldRandomize = false
            self.completeRolling()
        })
        .onAppear(perform: prepareHaptics)
    }
    
    func startRollDice() {
        shouldRandomize = true
        shouldAnimate = true
        
        let _ = randomizeTimer.connect()
        let _ = animationTimer.connect()
        
        do {
            try engine?.start()
        } catch {
            print("There was an error starting the engine: \(error.localizedDescription)")
        }
        
        startRollDiceHaptic()
    }
    
    func completeRolling() {
        //Gives a dice simulation from the GamePlayKit
        let dice = GKRandomDistribution(lowestValue: 1, highestValue: results.faces)
        
        shouldAnimate = false
        engine?.stop(completionHandler: nil)
        
        startRotation {
            outcome = dice.nextInt()
            
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
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func startRollDiceHaptic() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        for i in stride(from: 0.1, to: 5, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
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

struct DiceImageView: View {
    var body: some View {
        Image("dices")
            .resizable()
            .frame(width: 250, height: 250)
    }
}
