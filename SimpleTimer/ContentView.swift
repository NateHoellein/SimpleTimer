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
                ButtonsView(intervalTimer: self.intervalTimer, isPresented: self.$isPresented)
            }   
            .sheet(isPresented: $isPresented, onDismiss: {
                Task { await intervalTimer.start() }
            }) {
                CountDownOverlayView(showModal: $isPresented)
            }
        }
        
        if h_sizeClass == .compact && v_sizeClass == .compact ||
            h_sizeClass == .regular && v_sizeClass == .compact {
            HStack{
                TimerView(intervalTimer: self.intervalTimer)
                VStack {
                    SettingsView(intervalTimer: self.intervalTimer)
                    ButtonsView(intervalTimer: self.intervalTimer, isPresented: self.$isPresented)
                }
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                Task { await intervalTimer.start() }
            }) {
                CountDownOverlayView(showModal: $isPresented)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
