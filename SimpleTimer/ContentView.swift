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
    
    var body: some View {
        
        if h_sizeClass == .compact && v_sizeClass == .regular {
            VStack {
                TimerView(intervalTimer: self.intervalTimer)
                SettingsView(intervalTimer: self.intervalTimer)
                HStack {
                    Button(action: {
                        self.intervalTimer.stop()
                    }, label: {Image("stop")})
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    Button(action: {
                        
                        self.isPresented.toggle()
                        
                    }, label: {Image("start")}).sheet(isPresented: $isPresented, onDismiss: {
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
                            self.intervalTimer.stop()
                        }, label: {Image("stop")})
                        .buttonStyle(PlainButtonStyle())
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
