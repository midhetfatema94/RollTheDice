//
//  SettingsView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @State private var diceSides = "6"
    @State private var haptics = false
    
    @EnvironmentObject var results: DiceResults
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Settings.entity(), sortDescriptors: []) var diceSettings: FetchedResults<Settings>
    
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
                                    Button(action: saveData, label: {
                                        Text("Save")
                                    })
            )
            .navigationBarTitle("Settings")
            .onAppear(perform: {
                self.results.loadSettingsData(settings: diceSettings)
                self.diceSides = "\(self.results.diceSettings.faces)"
                self.haptics = self.results.diceSettings.haptics
            })
        }
    }
    
    func saveData() {
        results.updateSettings(haptics: self.haptics,
                               faces: Int(diceSides) ?? 6)
        
        do {
            let setting = Settings(context: self.moc)
            setting.currentFaces = Int16(diceSides) ?? 6
            setting.hapticControl = self.haptics
            try self.moc.save()
        } catch {
            print("Could not add new item in core data: \(error.localizedDescription)")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
