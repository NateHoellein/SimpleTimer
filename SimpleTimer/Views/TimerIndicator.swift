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
                .strokeBorder(lineWidth: 20.0, antialiased: true)
                .opacity(0.9)
                .foregroundColor(.gray)
                .modifier(TimerIndicator(pct: intervalTimer.progress))
                .padding()
            
            Circle()
                .strokeBorder(lineWidth: 10.0, antialiased: true)
                .opacity(0.9)
                .foregroundColor(.gray)
                .modifier(SetIndicator(pct: intervalTimer.setProgress))

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
        content.overlay(ArcShape(pct: pct)
                            .foregroundColor(.red))
                            .padding()
    }
    
    struct ArcShape: Shape {
        var pct: CGFloat
        
        func path(in rect: CGRect) -> Path {
            var p = Path()

            let diameter = min(rect.size.width, rect.size.height) - 20
            let radius = diameter / 2.0
            let center = CGPoint(x: rect.origin.x + rect.size.width / 2.0,
                                 y: rect.origin.y + rect.size.height / 2.0)
            let start = 270.0
            let end = (360.0 * Double(pct)) + 270
            
            p.addArc(center: center,
                     radius: radius,
                     startAngle: .degrees(start),
                     endAngle: .degrees(end), clockwise: false)
            
            return p.strokedPath(.init(lineWidth: 15, dash: [6, 3], dashPhase: 10))
        }
    }
}

struct SetIndicator: AnimatableModifier {
    
    var pct: CGFloat = 0
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(SetArcShape(pct: pct)
                        .foregroundColor(.white))
                        .padding()
    }
    
    struct SetArcShape: Shape {
        var pct: CGFloat
        
        func path(in rect: CGRect) -> Path {
            var p = Path()
            
            let diameter = min(rect.size.width, rect.size.height) - 10
            let radius = diameter / 2.0
            let center = CGPoint(x: rect.origin.x + rect.size.width / 2.0,
                                 y: rect.origin.y + rect.size.height / 2.0)
            let start = 270.0
            let end = (360.0 * Double(pct)) + 270
            
            p.addArc(center: center,
                     radius: radius,
                     startAngle: .degrees(start),
                     endAngle: .degrees(end), clockwise: false)
            return p.strokedPath(.init(lineWidth: 8))
        }
    }
}
