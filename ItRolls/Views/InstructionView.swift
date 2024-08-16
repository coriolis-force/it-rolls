//
//  InstructionView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/14/24.
//

import SwiftUI

struct InstructionView: View {
    @Binding var state: GameState
    
    var body: some View {
        Button(action: {state.enterLevelScreen()}) {
            VStack {
                Spacer()
                Spacer()
                Text("How to Play").font(.title)
                Spacer()
                Spacer()
                Spacer()
                Text("Tilt your device to roll the blue circle").font(.title)
                Spacer()
                Text("Each time two circles collide, they become smaller").font(.title)
                Spacer()
                Text("The objective is to reduce circle size to 0").font(.title)
                Spacer()
                Text("3 levels in total").font(.title)
                Spacer()
                Text("Tap the screen to pause/unpause").font(.title)
                Spacer()
                Text("Mute in the pause screen").font(.title)
                Spacer()
                Spacer()
                Spacer()
                Text("Tap to start").font(.title)
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var state = GameState()
        var body: some View {
            InstructionView(state: $state)
        }
    }
    return Preview()
}
