//
//  SettingsView.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 11/15/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    private let edgePadding = 24.0
    @ObservedObject var intervalTimer: IntervalTimer
    
    var body: some View {
        var interval: AttributedString {
            let intervalLabel = NSLocalizedString("Interval:", comment: "")
            var marked = AttributedString(intervalLabel)
            marked.font = .headline
            return marked
        }
        var sets: AttributedString {
            let intervalLabel = NSLocalizedString("Sets:", comment: "")
            var marked = AttributedString(intervalLabel)
            marked.font = .headline
            return marked
        }

        VStack {
            Text("\(interval) \(intervalTimer.intervalTimeDisplay)  \(sets) \( intervalTimer.intervalSets)")
                .padding([.bottom], 12)
            Stepper(value: $intervalTimer.intervalMinute,
                    in: 0 ... 10,
                    step: 1
            ) {
                Text(NSLocalizedString("Minutes",
                                       comment:"How many interval minutes"))
                .font(.title2)
            }
            .padding([.leading, .trailing], edgePadding)
            .padding([.bottom], 12)
            Stepper(value: $intervalTimer.intervalSeconds,
                    in: 0 ... 60,
                    step: 1
            ) {
                Text(NSLocalizedString("Seconds",
                                       comment: "How many interval seconds."))
                .font(.title2)
            }
            .padding([.leading, .trailing], edgePadding)
            .padding([.bottom], 12)
            Stepper(value: $intervalTimer.intervalSets,
                    in: 0 ... 50,
                    step: 1
            ) {
                Text(NSLocalizedString("Intervals",
                                       comment: "How many intervals"))
                .font(.title2)
            }
            .padding([.leading, .trailing], edgePadding)
        }
    }
}

#Preview {
    SettingsView(intervalTimer: IntervalTimer())
}
