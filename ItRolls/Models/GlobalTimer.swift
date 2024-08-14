//
//  GlobalTimer.swift
//  ItRolls
//
//  Created by Albert Dai on 7/4/24.
//

import Foundation
import Combine

@Observable
class GlobalTimer {
    static let refreshIntervak = 1.0/60
    var now = Date.now
    let timer = Timer.publish(every: refreshIntervak, on: .main, in: .common).autoconnect()
    private var cancellable: AnyCancellable? = nil
    
    init() {
        cancellable = timer.sink {
            self.now = $0
        }
    }
}
