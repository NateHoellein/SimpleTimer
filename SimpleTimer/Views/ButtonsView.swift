//
//  ButtonsView.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 12/5/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI

struct ButtonsView: View {
    
    @ObservedObject var intervalTimer: IntervalTimer
    @State var isPresented: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                self.stopButtonAction()
            }, label: { getStopLabel()})
            .buttonStyle(PlainButtonStyle())
            .disabled(self.intervalTimer.running == .running)
            .padding()
            Button(action: {
                startButtonAction()
            }, label: { getStartLabel() }).sheet(isPresented: $isPresented, onDismiss: {
                self.intervalTimer.start()
            }, content: {
                CountDownOverlayView(showModal: $isPresented)
            })
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }
    
    fileprivate func getStopLabel() -> Image {
        return Image( self.intervalTimer.running == .paused ? "Reset" : "Stop-1")
    }
    
    fileprivate func getStartLabel() -> Image {
        return Image( self.intervalTimer.running == .stopped ||
                        self.intervalTimer.running == .paused ? "Start-1" : "Paused")
    }
    
    fileprivate func stopButtonAction() {
        if self.intervalTimer.running == .running {
            self.intervalTimer.stop()
        }
        if self.intervalTimer.running == .paused {
            self.intervalTimer.reset()
        }
    }
    
    fileprivate func startButtonAction() {
        if self.intervalTimer.running == .stopped {
            self.isPresented.toggle()
        }
        if self.intervalTimer.running == .paused {
            self.isPresented.toggle()
        }
        if self.intervalTimer.running == .running {
            self.intervalTimer.pause()
        }
    }
}
