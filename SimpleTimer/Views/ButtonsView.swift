//
//  ButtonsView.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 12/5/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI

struct ButtonsView: View {
    private let buttonSize = 60.0
    @ObservedObject var intervalTimer: IntervalTimer
    @Binding var isPresented: Bool

    var body: some View {
        HStack {
            Button(action: {
                Task { await self.stopButtonAction() }
            }, label: {
                getStopLabel()
                    .font(.system(size: buttonSize))
                    .foregroundStyle(Color(.brickRed))
            })
            .disabled(self.intervalTimer.timerState == .running)
            .padding()
            Button(action: {
                Task { await startButtonAction() }
            }, label: {
                getStartLabel()
                    .font(.system(size: buttonSize))
                    .foregroundStyle(Color(.green))
            })
            .padding()
        }
    }
    //  Content to launch CountDownOverlayView - should just toggle ispresented?

    fileprivate func getStopLabel() -> Image {
        return Image(systemName: self.intervalTimer.timerState == .paused ?
                     "arrow.trianglehead.clockwise" :
                        "stop.circle")
    }
    
    fileprivate func getStartLabel() -> Image {
        return Image(systemName: self.intervalTimer.timerState == .stopped ||
                        self.intervalTimer.timerState == .paused ? "play.circle" : "pause.circle")
    }
    
    fileprivate func stopButtonAction() async {
        if self.intervalTimer.timerState == .running {
            await self.intervalTimer.stop()
        }
        if self.intervalTimer.timerState == .paused {
            await self.intervalTimer.reset()
        }
    }
    
    fileprivate func startButtonAction() async {
        if self.intervalTimer.timerState == .stopped {
            UIApplication.shared.isIdleTimerDisabled = false
            self.isPresented.toggle()
        }
        if self.intervalTimer.timerState == .paused {
            UIApplication.shared.isIdleTimerDisabled = false
            self.isPresented.toggle()
        }
        if self.intervalTimer.timerState == .running {
            UIApplication.shared.isIdleTimerDisabled = true
            await self.intervalTimer.pause()
        }
    }
}


#Preview {
    ButtonsView(intervalTimer: IntervalTimer(), isPresented: .constant(false))
}
