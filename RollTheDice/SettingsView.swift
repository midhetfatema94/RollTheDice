//
//  SettingsView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import SwiftUI

struct SettingsView: View {
    @State private var diceSides = "6"
    @State private var haptics = false
    @EnvironmentObject var results: DiceResults
    
    var body: some View {
        NavigationView {
            Form {
                TextField("No. of sides", text: $diceSides)
                    .keyboardType(.numberPad)
                
                Toggle(isOn: $haptics, label: {
                    Text("Add haptic feedback")
                })
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        results.faces = Int(diceSides) ?? 6
                                        results.haptics = self.haptics
                                    }, label: {
                                        Text("Save")
                                    })
            )
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
