//
//  CountDownOverlayView.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 11/15/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI
import AudioToolbox

struct CountDownOverlayView: View {
    @State var scale: CGFloat = 1
    @State var scale1: CGFloat = 1
    @State var scale2: CGFloat = 1
    @Binding var showModal: Bool
    
    var body: some View {
        
        
        VStack {
            CountDownBoxView(text: "3").padding()
                .scaleEffect(scale)
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 1.0)
                    let once = baseAnimation.repeatCount(1, autoreverses: false)
                    return withAnimation(once.delay(0.0)) {
                        self.scale = 0.0
                    }
                }
                .onAnimationCompleted(for: scale) {
                    AudioServicesPlayAlertSound(Sounds.countDown)
                }
            CountDownBoxView(text: "2").padding()
                .scaleEffect(scale1)
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 1.0)
                    let once = baseAnimation.repeatCount(1, autoreverses: false)
                    return withAnimation(once.delay(1.0)) {
                        self.scale1 = 0.0
                    
                    }
                }
                .onAnimationCompleted(for: scale1, completion: {
                    AudioServicesPlayAlertSound(Sounds.countDown)
                })
            CountDownBoxView(text: "1").padding()
                .scaleEffect(scale2)
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 1.0)
                    let once = baseAnimation.repeatCount(1, autoreverses: false)
                    return withAnimation(once.delay(2.0)) {
                        self.scale2 = 0.0
                        
                    }
                }
                .onAnimationCompleted(for: scale2, completion: {
                    AudioServicesPlayAlertSound(Sounds.countDown)
                    self.showModal.toggle()
                })
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.0))
    }
}

struct CountDownBoxView: View {
    var text: String
    var body: some View {
        Text(text)
            .frame(width: 150, height: 150, alignment: .center)
            .font(.system(size: 72.0))
            .foregroundColor(.white)
            .background(Rectangle()
                            .foregroundColor(.green)
                            .cornerRadius(10.0)
                            .transition(.asymmetric(insertion: .scale, removal: .opacity)))
    }
}
