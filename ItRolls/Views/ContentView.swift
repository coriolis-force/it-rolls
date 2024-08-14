//
//  ContentView.swift
//  ItRolls
//
//  Created by Albert Dai on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(GlobalTimer.self) var globalTimer
    @Environment(MotionData.self) var motionData

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! The current time is \(globalTimer.now)")
            Text("Device Angle Stats:")
            if let pitch = motionData.pitch {
                Text("Pitch: \(pitch)")
            } else {
                Text("Pitch unavailable 😢")
            }
            if let roll = motionData.roll {
                Text("Roll: \(roll)")
            } else {
                Text("Roll unavailable 😢")
            }
            if let yaw = motionData.yaw {
                Text("yaw: \(yaw)")
            } else {
                Text("Yaw unavailable 😢")
            }
            Text("More Random Stuff:")
            Text("Device Motion Available: \(motionData.deviceMotionAvailable)")
            if let error = motionData.error {
                Text("Error: \(error)")
            }
        }
        .padding()
    }
}

#Preview {
    //Text("")
    ContentView()
        .environment(GlobalTimer())
        .environment(MotionData())
}
