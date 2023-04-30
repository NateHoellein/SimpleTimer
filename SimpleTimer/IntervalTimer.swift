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
#if os(iOS)
import AudioToolbox
#endif

enum Timerstate {
    case running
    case paused
    case stopped
    case reset
}

actor DurationTimer {
    var accumulatedTime: TimeInterval = 0
    var intervalTime: TimeInterval = 0
    var advancedByPauseDifference: TimeInterval = 0
    var startTime: Date = Date()
    var pauseTime: Date = Date()

    func getElapsedTime() -> TimeInterval {
        return -(self.startTime.timeIntervalSinceNow) + self.advancedByPauseDifference
    }

    func getIntervalElapsedTime(currentInterval: Int, intervalDuration: Int) -> TimeInterval {
        let intervalCount = currentInterval - 1
        return (-(self.startTime.timeIntervalSinceNow) + self.advancedByPauseDifference) + self.intervalTime - TimeInterval(intervalCount * intervalDuration)
    }

    func pause(currentInterval: Int, intervalDuration: Int) {
        pauseTime = Date()
//        accumulatedTime = getElapsedTime()
//        intervalTime = getIntervalElapsedTime(currentInterval: currentInterval, intervalDuration: intervalDuration)
    }

    func resume() {
        advancedByPauseDifference += pauseTime.timeIntervalSince(Date())
//        startTime = startTime.addingTimeInterval(advancedByPauseDifference)
//        accumulatedTime += advancedByPauseDifference
        print("-- New Start Time: \(startTime)")
    }
//    func mark(currentInterval: Int, intervalDuration: Int) {
//        accumulatedTime = getElapsedTime()
//        intervalTime = getIntervalElapsedTime(currentInterval: currentInterval, intervalDuration: intervalDuration)
//    }

    func start() {
        startTime = Date()
        print("Start Time: \(startTime)")
    }

    func reset() {
        accumulatedTime = 0
        intervalTime = 0
    }

    func resetInterval() {
        intervalTime = 0
        print("------ reset interval: \(self.startTime) \(Thread.current) \(Thread.isMainThread)")
    }
}

class IntervalTimer: ObservableObject {
    private var currentSet: Int
    private var totalTicks: Int = 0
    private var alertRange: Range<Int> = Range(uncheckedBounds: (lower: 0, upper: 1))
    private var timer: Cancellable?
    private var previousProgress = 0
    private var duration: DurationTimer
    
    @Published var timerState: Timerstate = .stopped
    @Published var displayTime = "00:00"
    @Published var displayIntervalSet = ""
    @Published var progress: CGFloat = 0.0000
    @Published var overallProgress: CGFloat = 0.000
    @Published var intervalTimeDisplay: String = ""
    @Published var intervalMinute: Int = 2 {
        didSet {
            intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
            interval = intervalMinute * 60 + intervalSeconds
            totalTicks = intervalSets * interval
            alertRange = Range(uncheckedBounds: (lower: interval - 5, upper: interval))
        }
    }
    @Published var intervalSeconds: Int = 0 {
        didSet {
            intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
            interval = intervalMinute * 60 + intervalSeconds
            totalTicks = intervalSets * interval
            alertRange = Range(uncheckedBounds: (lower: interval - 5, upper: interval))
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
        print("IntervalTimer init")
        duration = DurationTimer()
        currentSet = 1
        totalTicks = intervalSets * interval
        displayIntervalSet = "\(currentSet) - \(intervalSets)"
        intervalTimeDisplay = String(format: "%d:%02d", intervalMinute, intervalSeconds)
    }
    
    deinit {
        print("IntervalTimer deinit")
        if let t = self.timer{
            t.cancel()
        }
    }
    
    func reset() async {
        DispatchQueue.main.async {
            self.timerState = .stopped
            self.interval = self.intervalMinute * 60 + self.intervalSeconds
            self.intervalTimeDisplay = String(format: "%d:%02d", self.intervalMinute, self.intervalSeconds)
            self.displayIntervalSet = "\(self.currentSet) - \(self.intervalSets)"
            self.displayTime = "00:00"
            self.progress = 0.0000
            self.overallProgress = 0.000
        }

        await duration.reset()
        previousProgress = 0
        currentSet = 1
        totalTicks = intervalSets * interval
        alertRange = Range(uncheckedBounds: (lower: interval - 5, upper: interval))
    }
    
    func pause() async {
        print("pause")
        DispatchQueue.main.async {
            self.timerState = .paused
        }
        await self.duration.pause(currentInterval: currentSet, intervalDuration: interval)
//        await duration.mark(currentInterval: currentSet, intervalDuration: interval)
        self.timer?.cancel()
    }
    
    func start() async {
        switch timerState {
        case .stopped:
            print("start from stopped")
            DispatchQueue.main.async {
                self.timerState = .running
            }
            await self.duration.start()
            await self.configureTimer()
            #if os(iOS)
            AudioServicesPlayAlertSound(Sounds.start)
            #endif
            //            await self.duration.mark(currentInterval: currentSet, intervalDuration: interval)
        case .paused:
            print("start from paused")
            DispatchQueue.main.async {
                self.timerState = .running
            }
            await self.duration.resume()
            await self.configureTimer()
            #if os(iOS)
            AudioServicesPlayAlertSound(Sounds.start)
            #endif
            //            await self.duration.mark(currentInterval: currentSet, intervalDuration: interval)
        case .running:
            timerState = .paused
        case .reset:
            timerState = .stopped
        }
    }
    
    func stop() async {
        switch timerState {
        case .running:
            self.timerState = .stopped
            self.timer?.cancel()
            self.timer = nil
//            await self.duration.mark(currentInterval: currentSet, intervalDuration: interval)
//            self.accumulatedTime = self.getElapsedTime()
        case .paused:
            print("PAUSED")
        case .reset:
            print("RESET")
        case .stopped:
            print("STOPPED")
        }
    }
    
    func updateDisplays(display: String,
                        intervalElapsedTime: TimeInterval,
                        elapsedTime: TimeInterval,
                        totalDisplayTime: String) async {

        DispatchQueue.main.async {
            self.displayTime = display
            self.progress = CGFloat(intervalElapsedTime / Double(self.interval))
            self.overallProgress = CGFloat(elapsedTime / Double(self.totalTicks))
        }

        if self.progress > 1.0 {
            await self.duration.resetInterval()
            self.currentSet += 1
            DispatchQueue.main.async {
                self.progress = 0.0
                self.displayIntervalSet = "\(self.currentSet) - \(self.intervalSets)"
            }
            #if os(iOS)
            AudioServicesPlayAlertSound(Sounds.start)
            #endif
        }

        if self.overallProgress >= 1.0 {
            self.timer?.cancel()
            await self.reset()
        }
        
//        let seconds = Int(self.getIntervalElapsedTime().rounded())
//        if alertRange.contains(seconds) && seconds != self.previousProgress {
//            AudioServicesPlayAlertSound(Sounds.countDown)
//            self.previousProgress = seconds
//        }
        
    }

    
    private static var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        formatter.allowsFractionalUnits = true
        return formatter
    }()
    
    private func configureTimer() async {
        self.timer?.cancel()
        self.timer = DispatchQueue
            .global(qos: .background)
            .schedule(after: DispatchQueue.SchedulerTimeType(.now()),
                      interval: DispatchQueue.SchedulerTimeType.Stride(.milliseconds(200)),
               { [weak self] in
                guard let self = self else { return }
                Task {
                    let intervalElapsedTime = await self.duration.getIntervalElapsedTime(currentInterval: self.currentSet,
                                                                                         intervalDuration: self.interval)
                    let intervalDisplayTime: String = IntervalTimer.formatter.string(from: intervalElapsedTime)!
                    let elapsedTime = await self.duration.getElapsedTime()
                    let totalDisplayTime: String = IntervalTimer.formatter.string(from: elapsedTime)!

                    print("Interval Elapsed Time \t\t \(intervalDisplayTime) | \(intervalDisplayTime) \t\t Elapsed Time \(elapsedTime) totalDisplayTime \(totalDisplayTime)")

                    await self.updateDisplays(display: intervalDisplayTime,
                                              intervalElapsedTime: intervalElapsedTime,
                                              elapsedTime: elapsedTime,
                                              totalDisplayTime: totalDisplayTime)
                }
            })
    }
}
