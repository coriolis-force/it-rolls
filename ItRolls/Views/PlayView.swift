//
//  PlayView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/14/24.
//

import SwiftUI

struct PlayView: View {
    let ballColor = Color.blue
    let targetColor = Color.red
    
    @Binding var state: GameState
    @Environment(GlobalTimer.self) var globalTimer
    @Environment(MotionData.self) var motionData
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("record") var record: TimeInterval = 0
    @AppStorage("recordDate") var recordDate: TimeInterval = 0
    
    var body: some View {
        ZStack {
            VStack {
                let currentTime = convertToTime(totalTime: state.gameRunningTime)
                Text(currentTime)
                Spacer()
                Text(currentTime)
            }
            Button(action: {state.enterPauseScreen()}) {
                GeometryReader { geometry in
                    Path {
                        path in
                        path.addArc(
                            center: state.targetPosition,
                            radius: state.radius,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 360),
                            clockwise: true)
                    }
                    .fill(targetColor)
                    Path {
                        path in
                        path.addArc(
                            center: state.ballPosition,
                            radius: state.radius,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 360),
                            clockwise: true)
                    }
                    .fill(ballColor)
                    .onAppear {
                        state.setStartingLocation(screenSize: geometry.size)
                    }
                    .onChange(of: scenePhase, { oldValue, newValue in
                        if newValue == .active {
                            state.currentTime = Date.now
                        }
                    })
                    .onReceive(globalTimer.timer) {
                        newTime in
                        state.moveCircle(newTime: newTime, screenSize: geometry.size, motionData: motionData, updateRecord: self.updateRecord)
                    }
                }
            }
        }
    }
    
    private func updateRecord(gameRunningTime: TimeInterval) {
        if gameRunningTime < record || record == 0 {
            recordDate = Date.now.timeIntervalSinceReferenceDate
            record = gameRunningTime
        }
    }

}

#Preview {
    struct Preview: View {
        @State var state = GameState()
        var body: some View {
            PlayView(state: $state)
        }
    }
    return Preview()
}
