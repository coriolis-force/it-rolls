//
//  PausedView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/14/24.
//

import SwiftUI

struct PausedView: View {
    @Binding var state: GameState
    
    var body: some View {
        Button(action: {state.enterGameScreen(resetGame: false)}) {
            VStack {
                Spacer()
                Text("Game Paused").font(.title)
                Text("Current Time: \(convertToTime(totalTime: state.gameRunningTime))").font(.title)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    struct Preview: View {
        @State var state = GameState()
        var body: some View {
            PausedView(state: $state)
        }
    }
    return Preview()
}
