//
//  SettingsView.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 11/15/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var intervalTimer: IntervalTimer
    
    var body: some View {
        
        VStack {
            Text("\(intervalTimer.intervalTimeDisplay)").font(.title)
            Stepper(value: $intervalTimer.intervalMinute,
                    in: 0 ... 10,
                    step: 1
            ) {
                Text("Minutes: \(intervalTimer.intervalMinute)").font(.title)
            }.padding()
            Stepper(value: $intervalTimer.intervalSeconds,
                    in: 0 ... 60,
                    step: 1
            ) {
                Text("Seconds: \(String(format: "%02d", intervalTimer.intervalSeconds))").font(.title)
            }.padding()
            Stepper(value: $intervalTimer.intervalSets,
                    in: 0 ... 50,
                    step: 1
            ) {
                Text("Intervals: \(intervalTimer.intervalSets)").font(.title)
            }.padding()
        }
    }
}
