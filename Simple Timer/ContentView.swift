//
//  ContentView.swift
//  Simple Timer
//
//  Created by Nathan Hoellein on 8/1/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI
let width = UIScreen.main.bounds.width

struct CountDownView: View {
    @ObservedObject var intervalTimer: IntervalTimer
    var body: some View {
        // geometry is not giving me size
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.9)
                    .foregroundColor(.gray)
                Circle()
                    .trim(from: 0.0, to: self.intervalTimer.progress)
                    .stroke(style: StrokeStyle(lineWidth: 19.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
                VStack {
                    Text("\(self.intervalTimer.displayTime)")
                        .font(.largeTitle)
                        .padding()
                    Text("\(self.intervalTimer.displayIntervalSet)")
                        .font(.title)
                }
            }
            .padding()
        }
    }
}

struct ContentView: View {
    @ObservedObject var intervalTimer = IntervalTimer()
    var body: some View {
        VStack{
            CountDownView(intervalTimer: intervalTimer)
            HStack {
                Button(action: {
                    self.intervalTimer.stop()
                }, label: {Image("stop")})
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                Text("2:00")
                    .font(.headline)
                    .padding()
                Button(action: {
                    self.intervalTimer.start()
                }, label: {Image("start")})
                    .buttonStyle(PlainButtonStyle())
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}