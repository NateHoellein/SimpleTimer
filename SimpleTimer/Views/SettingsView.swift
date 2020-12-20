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
                Text(NSLocalizedString("Minutes: \(intervalTimer.intervalMinute)", comment:"How many interval minutes")).font(.title)
            }.padding()
            Stepper(value: $intervalTimer.intervalSeconds,
                    in: 0 ... 60,
                    step: 1
            ) {
                Text(NSLocalizedString("Seconds: \(String(format: "%02d", intervalTimer.intervalSeconds))", comment: "How many interval seconds.")).font(.title)
            }.padding()
            Stepper(value: $intervalTimer.intervalSets,
                    in: 0 ... 50,
                    step: 1
            ) {
                Text(NSLocalizedString("Intervals: \(intervalTimer.intervalSets)", comment: "How many intervals")).font(.title)
            }.padding()
        }
    }
}
