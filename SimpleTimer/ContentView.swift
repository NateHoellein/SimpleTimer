//
//  ContentView.swift
//  Simple Timer
//
//  Created by Nathan Hoellein on 8/1/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var intervalTimer = IntervalTimer()
    @State var isPresented = false
    
    @Environment(\.horizontalSizeClass) var h_sizeClass
    @Environment(\.verticalSizeClass) var v_sizeClass
    
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
    
    var body: some View {
            
        if h_sizeClass == .compact && v_sizeClass == .regular {
            VStack {
                TimerView(intervalTimer: self.intervalTimer)
                SettingsView(intervalTimer: self.intervalTimer)
                HStack {
                    Button(action: {
                        stopButtonAction()
                    }, label: { getStopLabel() })
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
        }
        
        if h_sizeClass == .compact && v_sizeClass == .compact ||
            h_sizeClass == .regular && v_sizeClass == .compact {
            HStack{
                TimerView(intervalTimer: self.intervalTimer)
                VStack {
                    SettingsView(intervalTimer: self.intervalTimer)
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
