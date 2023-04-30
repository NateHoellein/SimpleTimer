//
//  Simple_TimerTests.swift
//  Simple TimerTests
//
//  Created by Nathan Hoellein on 10/3/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import XCTest

@testable import Simple_Timer

class TimerDisplayTests: XCTestCase {

    func testChangeIntervalSets() {
        let intervalTimer = IntervalTimer()
        XCTAssertEqual(10, intervalTimer.intervalSets)
        intervalTimer.intervalSets += 1
        XCTAssertEqual(11, intervalTimer.intervalSets)
    }
    
    func testChangeIntervalSetChangesDisplayWhenIncreased() {
        let intervalTimer = IntervalTimer()
        XCTAssertEqual("1 - 10", intervalTimer.displayIntervalSet)
        intervalTimer.intervalSets += 1
        XCTAssertEqual("1 - 11", intervalTimer.displayIntervalSet)
    }
    
    func testChangeIntervalSetChangesDisplayWhenDecreased() {
        let intervalTimer = IntervalTimer()
        XCTAssertEqual("1 - 10", intervalTimer.displayIntervalSet)
        intervalTimer.intervalSets -= 1
        XCTAssertEqual("1 - 9", intervalTimer.displayIntervalSet)
    }

    func testCalculateIntervalTimeFromMinutes() {
        let intervalTimer = IntervalTimer()
        XCTAssertEqual(120, intervalTimer.interval)
    }

    func testCalculateIntervalTimeOneMinute() {
        let intervalTimer = IntervalTimer()
        intervalTimer.intervalMinute = 1
        XCTAssertEqual(60, intervalTimer.interval)
    }

    func testCalculateIntervalTimeOneMinuteAndOneSecond() {
        AssertInterval(minutes: 1, seconds: 1, expectedInterval: 61)
    }

    func testCalculateIntervalTimeTwoMinutesAndThirtyOneSeconds() {
        AssertInterval(minutes: 2, seconds: 31, expectedInterval: 151)
    }

    func testCalculateIntervalTime0MinutesAndThirtyOneSeconds() {
        AssertInterval(minutes: 0, seconds: 31, expectedInterval: 31)
    }
    
    fileprivate func AssertInterval(minutes: Int, seconds: Int, expectedInterval: Int) {
        let intervalTimer = IntervalTimer()
        intervalTimer.intervalMinute = minutes
        intervalTimer.intervalSeconds = seconds
        XCTAssertEqual(expectedInterval, intervalTimer.interval)
    }
}
