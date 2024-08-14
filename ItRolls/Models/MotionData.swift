//
//  MotionData.swift
//  ItRolls
//
//  Created by Albert Dai on 7/4/24.
//

import Foundation
import CoreMotion

@Observable
class MotionData {
    let motionManager = CMMotionManager()
    let deviceMotionAvailable: Bool
    var roll: Double?
    var pitch: Double?
    var yaw: Double?
    var error: Error?
    
    init() {
        deviceMotionAvailable = motionManager.isDeviceMotionAvailable
        if deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = GlobalTimer.refreshIntervak
            motionManager.showsDeviceMovementDisplay = true
            motionManager.startDeviceMotionUpdates(using:.xArbitraryCorrectedZVertical, to: OperationQueue.main) {
                data,error in
                self.roll = data?.attitude.roll
                self.pitch = data?.attitude.pitch
                self.yaw = data?.attitude.yaw
                self.error = error
            }
        }
    }
}
