//
//  LevelView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/14/24.
//

import SwiftUI

struct LevelView: View {
    @Binding var state: GameState
    @Environment(GlobalTimer.self) var globalTimer
    
    var body: some View {
        VStack{
            state.level.view()
            if state.level != .level1 {
                Text("Current Time: \(convertToTime(totalTime: state.gameRunningTime))")
            }
        }
        .font(.title)
        .onReceive(globalTimer.timer) {
            newTime in
            state.enterGameScreen(after: 2, newTime: newTime)
        }
    }
}

#Preview {
    struct Preview: View {
        @State var state = GameState()
        var body: some View {
            LevelView(state: $state)
        }
    }
    return Preview()
}
