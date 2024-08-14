//
//  GameView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/4/24.
//

import SwiftUI
import UIKit

private let startAcceleration: CGFloat = 400

func convertToTime(totalTime: TimeInterval) -> String {
    var remainingTime = totalTime.milliseconds
    let milliseconds = remainingTime % 1000
    remainingTime -= milliseconds
    remainingTime /= 1000
    let seconds = remainingTime % 60
    remainingTime -= seconds
    remainingTime /= 60
    let minutes = remainingTime
    let millisecondsString = String(format: "%03d", milliseconds)
    let secondsString = String(format: "%02d", seconds)
    let minutesString = String(format: "%02d", minutes)
    return "\(minutesString):\(secondsString).\(millisecondsString)"
}

extension TimeInterval {
    var milliseconds: Int {
        return Int(self * 1000)
    }
}

extension GameState.Level {
    func view() -> some View {
        switch self {
        case .level1: Text("Level 1")
        case .level2: Text("Level 2")
        case .level3: Text("Level 3")
        }
    }
}

struct GameView: View {
    @Environment(GlobalTimer.self) var globalTimer
    @Environment(MotionData.self) var motionData
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("record") var record: TimeInterval = 0
    @AppStorage("recordDate") var recordDate: TimeInterval = 0
    @State var state = GameState()
    
    var body: some View {
        switch state.currentScreenState {
            case .instruction: instructionScreen
            case .level: levelScreen
            case .gameOngoing: gameScreen
            case .gamePaused: pausedScreen
            case .victory: victoryScreen
        }
    }
    
    var instructionScreen: some View {
        InstructionView(state: $state)
    }

    var levelScreen: some View {
        LevelView(state: $state)
    }
    
    var gameScreen: some View {
        PlayView(state: $state)
    }
    
    var pausedScreen: some View {
        PausedView(state: $state)
    }
    
    var victoryScreen: some View {
        VictoryView(state: $state)
    }
}

#Preview {
    GameView()
        .environment(GlobalTimer())
        .environment(MotionData())
}
