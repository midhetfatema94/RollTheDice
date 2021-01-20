//
//  RollHistoryView.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/20/21.
//

import SwiftUI

struct RollHistoryView: View {
    @EnvironmentObject var results: DiceResults
    
    var body: some View {
        List {
            ForEach(results.results, content: {eachResult in
                Text("\(eachResult.result)/\(eachResult.faces)")
            })
        }
    }
}

struct RollHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RollHistoryView()
    }
}
