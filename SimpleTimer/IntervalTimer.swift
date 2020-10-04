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
    private var sourceTimer: DispatchSourceTimer?
    private var queue: DispatchQueue?
    private var counter: Int
    private var currentSet: Int
    
    @Published var displayTime = "00:00"
    @Published var displayIntervalSet = ""
    @Published var progress: CGFloat = 0.0000
    @Published var setComplete: Bool = false
    @Published var intervalTimeDisplay: String = ""
    @Published var intervalMinute: Int = 2 {
        didSet {
            intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
            interval = intervalMinute * 60 + intervalSeconds
        }
    }
    @Published var intervalSeconds: Int = 0 {
        didSet {
            intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
            interval = intervalMinute * 60 + intervalSeconds
        }
    }
    @Published var interval: Int = 120
    @Published var intervalSets: Int = 10 {
        didSet {
            displayIntervalSet = "\(currentSet) - \(intervalSets)"
        }
    }
    
    init() {
        currentSet = 1
        counter = 0
        
        self.queue = DispatchQueue(label: "com.4bitshift.intervaltimer")
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: self.queue)
        
        intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
        displayIntervalSet = "\(currentSet) - \(intervalSets)"
    }
    
    deinit {
        if let t = self.sourceTimer {
            t.cancel()
            t.resume()
        }
    }
    
    func start() {
        print("start")
        self.sourceTimer?.setEventHandler {
            self.updateDisplays()
        }
        
        self.sourceTimer?.schedule(deadline: .now(), repeating: 1.0)
        self.sourceTimer?.resume()
    }
    
    func stop() {
        print("stop")
        self.sourceTimer?.suspend()
    }
    
    func updateDisplays() {
        
        DispatchQueue.main.async {
            
            print(self.counter)
            self.progress = CGFloat(Double(self.counter + 1) / Double(self.interval))
            print(self.progress)
            self.displayTime = IntervalTimer.display(self.counter)

            if ((self.interval - 5)...self.interval).contains(self.counter) {
                print("Beep  counter: \(self.counter)")
                AudioServicesPlayAlertSound(Sounds.countDown)
            }
              
            if self.counter == self.interval &&
                self.currentSet == self.intervalSets {
                // all done
                print("All done")
                self.setComplete = true
                self.sourceTimer?.suspend()
                return
            }
            
            if self.counter == self.interval {
                print("Interval done")
                self.counter = 0
                self.progress = 1.0
                self.currentSet += 1
                self.displayIntervalSet = "\(self.currentSet) - \(self.intervalSets)"
            }
            self.counter += 1
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
