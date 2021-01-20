//
//  ContentView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/18/21.
//

import SwiftUI

struct ContentView: View {
    var results = DiceResults()
    
    var body: some View {
        TabView {
            RollTheDiceView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Roll the Dice")
                }

            RollHistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }
        .environmentObject(results)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
