//
//  AudioEffect.swift
//  ItRolls
//
//  Created by Albert Dai on 8/15/24.
//

import Foundation
import AudioToolbox
import OSLog

@Observable
class AudioEffect {
    enum SoundType {
        case bounce
        case elimination
        case advanceLevel
        case victory
    }
    
    var muted: Bool {
        didSet {
            UserDefaults().setValue(muted, forKey: mutedKey)
        }
    }
    
    private let mutedKey = "muted"
    private let logger = Logger()
    private let soundIDs: [SoundType: SystemSoundID]
    
    init() {
        muted = UserDefaults().bool(forKey: mutedKey)
        let fileNames = [SoundType.bounce: "PINEnterDigit_AX.caf",
                         SoundType.elimination: "PINDelete_AX.caf",
                         SoundType.advanceLevel: "PINSubmit_AX.caf",
                         SoundType.victory: "New/Fanfare.caf"]
        soundIDs = fileNames.mapValues {
            let url = URL(fileURLWithPath: "/System/Library/Audio/UISounds/" + $0)
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            return soundID
        }
    }
    
    func play(_ soundType: SoundType) {
        guard !muted else {
            return
        }
        guard let soundID = soundIDs[soundType] else {
            logger.error("Error: Unexpectedly found nil when unwrapping soundID of type \(String(describing: soundType))")
            return
        }
        AudioServicesPlaySystemSound(soundID)
    }
}
