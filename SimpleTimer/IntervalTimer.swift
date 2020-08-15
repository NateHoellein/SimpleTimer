//
//  IntervalTimer.swift
//  Simple Timer
//
//  Created by Nathan Hoellein on 8/1/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import AudioToolbox

class IntervalTimer: ObservableObject {
    private var sourceTimer: DispatchSourceTimer
    private var queue: DispatchQueue
    private var counter: Int
    private var interval: Int
    private var currentInterval: Int
    private var intervalDuration: Int
    private var intervalProgress: Int
    
    @Published var displayTime = "00:00"
    @Published var displayIntervalSet = ""
    @Published var progress: CGFloat = 0.0000
    @Published var setComplete: Bool = false
    
    init() {
        interval = 10
        intervalProgress = 1
        currentInterval = 1
        counter = 0
        intervalDuration = 120
        displayIntervalSet = "\(currentInterval) - \(interval)"
        self.queue = DispatchQueue(label: "com.4bitshift.intervaltimer")
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict,
                                                               queue: self.queue)
    }
    
    func start() {
        print("start")
        self.sourceTimer.setEventHandler {
            self.updateDisplays()
        }
        
        self.sourceTimer.schedule(deadline: .now(), repeating: 1.0)
        self.sourceTimer.resume()
    }
    
    func stop() {
        print("stop")
        self.sourceTimer.suspend()
    }
    
    func updateDisplays() {
        
        DispatchQueue.main.async {
            self.counter += 1
            
            if ((self.intervalDuration - 5)...self.intervalDuration).contains(self.counter) {
                AudioServicesPlayAlertSound(Sounds.countDown)
            }
            
            if self.counter == self.intervalDuration &&
                self.currentInterval == self.interval {
                // all done
                self.setComplete = true
                return
            }
            
            if self.counter == self.intervalDuration {
                self.counter = 0
                self.progress = 0.000
                self.currentInterval += 1
                self.displayIntervalSet = "\(self.currentInterval) - \(self.interval)"
            }
            
            self.progress = CGFloat(Double(self.counter) / Double(120))
            self.displayTime = IntervalTimer.display(self.counter)

        }
    }
}

extension IntervalTimer {
    static func display(_ c: Int) -> String {
        let minutes = c / 60
        let seconds = c - (minutes * 60)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
