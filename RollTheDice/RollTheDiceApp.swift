//
//  RollTheDiceApp.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/18/21.
//

import SwiftUI

@main
struct RollTheDiceApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
