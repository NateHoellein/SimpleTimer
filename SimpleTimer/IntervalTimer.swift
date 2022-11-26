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

enum Timerstate {
    case running
    case paused
    case stopped
    case reset
}

class IntervalTimer: ObservableObject {
    private var sourceTimer: DispatchSourceTimer?
    private var queue: DispatchQueue?
    private var counter: Int
    private var currentSet: Int
    private var totalTicks: Int = 0
    private var accumulatedTicks: Int
    
    @Published var running: Timerstate = .stopped
    @Published var displayTime = "00:00"
    @Published var displayIntervalSet = ""
    @Published var progress: CGFloat = 0.0000
    @Published var setProgress: CGFloat = 0.000
    @Published var intervalTimeDisplay: String = ""
    @Published var intervalMinute: Int = 2 {
        didSet {
            intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
            interval = intervalMinute * 60 + intervalSeconds
            totalTicks = intervalSets * interval
        }
    }
    @Published var intervalSeconds: Int = 0 {
        didSet {
            intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
            interval = intervalMinute * 60 + intervalSeconds
            totalTicks = intervalSets * interval
        }
    }
    @Published var interval: Int = 120
    @Published var intervalSets: Int = 10 {
        didSet {
            displayIntervalSet = "\(currentSet) - \(intervalSets)"
            totalTicks = intervalSets * interval
        }
    }

    init() {
        currentSet = 1
        counter = 0

        accumulatedTicks = 0
        totalTicks = intervalSets * interval
        
        self.queue = DispatchQueue(label: "com.4bitshift.intervaltimer")
        self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: self.queue)
        self.sourceTimer?.setEventHandler {
            self.updateDisplays()
        }

        intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
        displayIntervalSet = "\(currentSet) - \(intervalSets)"

    }
    
    deinit {
        if let t = self.sourceTimer {
            t.cancel()
            t.resume()
        }
    }
    
    func reset() {
        self.running = .stopped
        
        currentSet = 1
        counter = 0
        accumulatedTicks = 0
        totalTicks = 0
        progress = 0.0000
        setProgress = 0.000
        interval = intervalMinute * 60 + intervalSeconds
        intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
        displayIntervalSet = "\(currentSet) - \(intervalSets)"
        displayTime = "00:00"
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func pause() {
        print("pause")
        self.running = .paused
        self.sourceTimer?.suspend()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
        switch running {
            case .stopped:
                running = .running
                self.sourceTimer?.schedule(deadline: .now(), repeating: 1.0)
                self.sourceTimer?.resume()
                AudioServicesPlayAlertSound(Sounds.start)
            
            case .paused:
                running = .running
                self.sourceTimer?.schedule(deadline: .now(), repeating: 1.0)
                self.sourceTimer?.resume()
                AudioServicesPlayAlertSound(Sounds.start)
            case .running:
                running = .paused
            case .reset:
                running = .stopped
        }
    }
    
    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
        switch running {
        case .running:
            self.running = .stopped
            self.sourceTimer?.suspend()
        case .paused:
            print("PAUSED")
        case .reset:
            print("RESET")
        case .stopped:
            print("STOPPED")
        }
    }
    
    func updateDisplays() {
        DispatchQueue.main.async {
            self.progress = CGFloat(Double(self.counter) / Double(self.interval))
            self.setProgress = CGFloat(Double(self.accumulatedTicks) / Double(self.totalTicks))

            self.displayTime = IntervalTimer.display(self.counter)

            if ((self.interval - 5)...self.interval).contains(self.counter) {
                AudioServicesPlayAlertSound(Sounds.countDown)
            }

            if self.counter == self.interval &&
                self.currentSet == self.intervalSets {
                self.sourceTimer?.suspend()
                self.reset()
                return
            }

            if self.counter == self.interval {
                AudioServicesPlayAlertSound(Sounds.start)
                self.counter = 0
                self.progress = 1.0
                self.currentSet += 1
                self.displayIntervalSet = "\(self.currentSet) - \(self.intervalSets)"
            }
            self.counter += 1
            self.accumulatedTicks += 1
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
