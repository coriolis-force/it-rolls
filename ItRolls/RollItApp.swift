//
//  RollItApp.swift
//  RollIt
//
//  Created by Albert Dai on 7/4/24.
//

import SwiftUI

@main
struct RollItApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView().environment(GlobalTimer()).environment(MotionData())
            GameView().environment(GlobalTimer()).environment(MotionData())
        }
    }
}
