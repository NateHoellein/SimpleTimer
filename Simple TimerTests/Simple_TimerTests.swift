//
//  Simple_TimerTests.swift
//  Simple TimerTests
//
//  Created by Nathan Hoellein on 8/2/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import XCTest
@testable import Simple_Timer

class Simple_TimerTests: XCTestCase {

    func testTimeDisplay() {
        let timeDisplay = IntervalTimer.display(1)
        XCTAssertEqual("00:01", timeDisplay)
    }
    
    func testTimeDisplay_OneMinute() {
        let timeDisplay = IntervalTimer.display(60)
        XCTAssertEqual("01:00", timeDisplay)
    }
    
    func testTimeDisplay_OneMinute_25Seconds() {
        let timeDisplay = IntervalTimer.display(85)
        XCTAssertEqual("01:25", timeDisplay)
    }

    func testTimeDisplay_Two_Minutes() {
        let timeDisplay = IntervalTimer.display(121)
        XCTAssertEqual("02:01", timeDisplay)
    }
}
