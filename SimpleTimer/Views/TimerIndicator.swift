//
//  TimerIndicator.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 10/14/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI


struct TimerView: View {
    
    @ObservedObject var intervalTimer: IntervalTimer
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.9)
                .foregroundColor(.gray)
                .modifier(TimerIndicator(pct: intervalTimer.progress))
            VStack {
                Text("\(self.intervalTimer.displayTime)")
                    .font(.largeTitle)
                    .padding()
                Text("\(self.intervalTimer.displayIntervalSet)")
                    .font(.title)
            }
        }
    }
}

struct TimerIndicator: AnimatableModifier {

    var pct: CGFloat = 0

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(ArcShape(pct: pct).foregroundColor(.red)).padding()
    }
    
    struct ArcShape: Shape {
        var pct: CGFloat
        
        func path(in rect: CGRect) -> Path {
            var p = Path()
            
            let start = 270.0
            let end = (360.0 * Double(pct)) + 270
            
            p.addArc(center: CGPoint(x: rect.width / 2.0, y:rect.height / 2.0),
                     radius: rect.width / 2.0,
                     startAngle: .degrees(start),
                     endAngle: .degrees(end), clockwise: false)
            
            return p.strokedPath(.init(lineWidth: 19, dash: [6, 3], dashPhase: 10))
        }
    }
}
