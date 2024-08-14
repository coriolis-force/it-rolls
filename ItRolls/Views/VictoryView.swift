//
//  VictoryView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/14/24.
//

import SwiftUI

struct VictoryView: View {
    @Binding var state: GameState
    @AppStorage("record") var record: TimeInterval = 0
    @AppStorage("recordDate") var recordDate: TimeInterval = 0
    @State var showingClearRecordAlert = false
    
    let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {state.enterLevelScreen(resetGameRunningTime: true)}) {
                VStack {
                    Text("Congratulations, you win!").font(.title)
                    Text("Time: \(convertToTime(totalTime: state.gameRunningTime))")
                    if record > 0 {
                        Text("Best Time: \(convertToTime(totalTime: record)) ")
                        Text("on \(dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: recordDate)))")
                    }
                    Text("Tap to play again").font(.title2)
                }
            }
            Spacer()
            if record > 0 {
                Button(action: {showingClearRecordAlert = true}) {
                    Text("Tap to clear the record").font(.title2)
                }
                .alert("Are you sure you want to clear the record?", isPresented: $showingClearRecordAlert) {
                    Button("No", role: .cancel) {}
                    Button("Yes", role: .destructive) {record = 0}
                }
                Spacer()
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var state = GameState()
        var body: some View {
            VictoryView(state: $state)
        }
    }
    return Preview()
}
