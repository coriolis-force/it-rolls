//
//  GameState.swift
//  ItRolls
//
//  Created by Albert Dai on 7/13/24.
//

import Foundation
import UIKit

private let screenshotMode = false
private let startAcceleration: CGFloat = 400

struct GameState {
    
    enum ScreenState {
        case instruction
        case level
        case gameOngoing
        case gamePaused
        case victory
    }
    
    enum Level {
        case level1
        case level2
        case level3
        func next() -> Level {
            switch self {
            case .level1: .level2
            case .level2: .level3
            case .level3: .level1
            }
        }
    }
    
    private var immediateAdvanceLevel = false
    
    var radius: CGFloat = 60
    var ballPosition: CGPoint = .zero
    var ballVelocity: CGVector = .zero
    var currentTime = Date.now
    var targetPosition: CGPoint = .zero
    var level = Level.level1
    var acceleration: CGFloat = startAcceleration
    var radiusDecreaseIntervals: CGFloat = 6
    var gameRunningTime: TimeInterval = 0
    var currentScreenState: ScreenState = .instruction {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = currentScreenState == .gameOngoing
        }
    }
    
    private func isInContact(position1: CGPoint, position2: CGPoint, radius: CGFloat) -> Bool {
        let distance = (position1.x-position2.x)*(position1.x-position2.x) +
        (position1.y-position2.y)*(position1.y-position2.y)
        if distance <= radius*radius*4 {
            return true
        }
        return false
    }
    
    mutating func enterGameScreen(after: TimeInterval, newTime: Date) {
        if newTime.timeIntervalSince(currentTime) >= after {
            enterGameScreen(resetGame: true)
        }
    }
    
    mutating func setStartingLocation(screenSize: CGSize) {
        if ballPosition == .zero && targetPosition == .zero {
            ballPosition.x = CGFloat.random(in: screenSize.width * 0.2 + radius...screenSize.width * 0.8 - radius)
            ballPosition.y = CGFloat.random(in: screenSize.height * 0.2 + radius...screenSize.height * 0.8 - radius)
            generateTargetLocation(screenSize: screenSize)
        }
    }

    mutating func moveCircle(newTime: Date, screenSize: CGSize, motionData: MotionData, updateRecord: (TimeInterval) -> Void, audioEffect: AudioEffect) {
        defer { currentTime = newTime }
        let appActiveState = UIApplication.shared.applicationState
        guard appActiveState == .active && currentScreenState == .gameOngoing else {
            return
        }
        let deltaTime = newTime.timeIntervalSince(currentTime)
        gameRunningTime += deltaTime
        ballPosition.x += ballVelocity.dx * deltaTime
        if ballPosition.x - radius < 0 {
            ballPosition.x = radius
            ballVelocity.dx = -ballVelocity.dx / 2
            audioEffect.play(.bounce)
        } else if ballPosition.x + radius > screenSize.width {
            ballPosition.x = screenSize.width-radius
            ballVelocity.dx = -ballVelocity.dx / 2
            audioEffect.play(.bounce)
        }
        ballPosition.y += ballVelocity.dy * deltaTime
        if ballPosition.y - radius < 0 {
            ballPosition.y = radius
            ballVelocity.dy = -ballVelocity.dy / 2
            audioEffect.play(.bounce)
        } else if ballPosition.y + radius > screenSize.height {
            ballPosition.y = screenSize.height-radius
            ballVelocity.dy = -ballVelocity.dy / 2
            audioEffect.play(.bounce)
        }
        if (isInContact(position1: ballPosition, position2: targetPosition, radius: radius)) {
            generateTargetLocation(screenSize: screenSize)
            radius -= radiusDecreaseIntervals
            if radius == 0 {
                advanceLevel(updateRecord: updateRecord, audioEffect: audioEffect)
            } else {
                audioEffect.play(.elimination)
            }
        }
        let rollAcceleration = (motionData.roll ?? 0)*acceleration*deltaTime
        let pitchAcceleration = (motionData.pitch ?? 0)*acceleration*deltaTime
        if UIDevice.current.userInterfaceIdiom == .phone {
            ballVelocity.dx += rollAcceleration
            ballVelocity.dy += pitchAcceleration
        } else {
            ballVelocity.dx += pitchAcceleration
            ballVelocity.dy -= rollAcceleration
        }
        if screenshotMode && immediateAdvanceLevel {
            gameRunningTime += TimeInterval.random(in: 20...30)
            advanceLevel(updateRecord: updateRecord, audioEffect: audioEffect)
        }
    }
    
    private mutating func advanceLevel(updateRecord: (TimeInterval) -> Void, audioEffect: AudioEffect) {
        level = level.next()
        if level == .level1 {
            audioEffect.play(.victory)
            enterVictoryScreen(updateRecord: updateRecord)
            return
        }
        audioEffect.play(.advanceLevel)
        acceleration += 200
        radiusDecreaseIntervals -= 1
        enterLevelScreen()
    }
    
    mutating func enterLevelScreen(resetGameRunningTime: Bool = false) {
        if resetGameRunningTime {
            gameRunningTime = 0
        }
        currentScreenState = .level
        currentTime = Date.now
    }
    
    mutating func enterGameScreen(resetGame: Bool) {
        currentScreenState = .gameOngoing
        currentTime = Date.now
        if resetGame {
            radius = 60
            ballVelocity = .zero
            ballPosition = .zero
            targetPosition = .zero
            if screenshotMode {
                if level == .level2 {
                    radius = 25
                } else if level == .level3 {
                    radius = 8
                }
            }
        }
        if screenshotMode {
            immediateAdvanceLevel = !resetGame
        }
    }
    
    mutating func enterPauseScreen() {
        currentScreenState = .gamePaused
    }
    
    private mutating func enterVictoryScreen(updateRecord: (TimeInterval) -> Void) {
        updateRecord(gameRunningTime)
        currentScreenState = .victory
        acceleration = startAcceleration
        radiusDecreaseIntervals = 6
    }
    
    private mutating func generateTargetLocation(screenSize: CGSize) {
        repeat {
            targetPosition.x = .random(in: radius...screenSize.width-radius)
            targetPosition.y = .random(in: radius...screenSize.height-radius)
        } while isInContact(position1: ballPosition, position2: targetPosition, radius: radius)
    }
}
