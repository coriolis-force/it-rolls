//
//  PausedView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/14/24.
//

import SwiftUI

struct PausedView: View {
    @Binding var state: GameState
    @Environment(AudioEffect.self) var audioEffect
    
    var body: some View {
        ZStack {
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
            VStack {
                Spacer()
                Spacer()
                    Button(action: {toggleMute()}) {
                    if audioEffect.muted {
                        Text("Unmute").font(.title)
                    } else {
                        Text("Mute").font(.title)
                    }
                }
                Spacer()
            }
        }
    }
    
    private func toggleMute() {
        audioEffect.muted = !audioEffect.muted
    }
}

#Preview {
    struct Preview: View {
        @State var state = GameState()
        var body: some View {
            PausedView(state: $state)                .environment(GlobalTimer())
                .environment(MotionData())
                .environment(AudioEffect())

        }
    }
    return Preview()
}
