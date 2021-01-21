//
//  ContentView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/18/21.
//

import SwiftUI

struct ContentView: View {
    var results = DiceResults()
    
    @FetchRequest(entity: DiceResult.entity(), sortDescriptors: []) var diceResults: FetchedResults<DiceResult>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        TabView {
            RollTheDiceView()
                .environment(\.managedObjectContext, moc)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Roll the Dice")
                }

            RollHistoryView()
                .environment(\.managedObjectContext, moc)
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
        }
        .environmentObject(results)
        .onAppear(perform: {
            results.loadData(diceResults: self.diceResults)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
