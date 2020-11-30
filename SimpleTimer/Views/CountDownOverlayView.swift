//
//  CountDownOverlayView.swift
//  SimpleTimer
//
//  Created by Nathan Hoellein on 11/15/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import SwiftUI

struct CountDownOverlayView: View {
    @State var scale: CGFloat = 1
    @State var scale1: CGFloat = 1
    @State var scale2: CGFloat = 1
    @Binding var showModal: Bool
    
    @Environment(\.horizontalSizeClass) var h_sizeClass
    @Environment(\.verticalSizeClass) var v_sizeClass
    
    var body: some View {
        
        
        if h_sizeClass == .compact && v_sizeClass == .regular {
        
            VStack {
                CountDownBoxView(text: "3").padding()
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.0)
                        let once = baseAnimation.repeatCount(1, autoreverses: false)
                        return withAnimation(once.delay(0.5)) {
                            self.scale = 0.0
                        }
                    }
                CountDownBoxView(text: "2").padding()
                    .scaleEffect(scale1)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.0)
                        let once = baseAnimation.repeatCount(1, autoreverses: false)
                        return withAnimation(once.delay(1.5)) {
                            self.scale1 = 0.0
                        }
                    }
                CountDownBoxView(text: "1").padding()
                    .scaleEffect(scale2)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.0)
                        let once = baseAnimation.repeatCount(1, autoreverses: false)
                        return withAnimation(once.delay(2.5)) {
                            self.scale2 = 0.0
                        }
                    }
                    .onAnimationCompleted(for: scale2, completion: {
                        self.showModal.toggle()
                    })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.0))
        }
        
        if h_sizeClass == .compact && v_sizeClass == .compact ||
            h_sizeClass == .regular && v_sizeClass == .compact {
            HStack {
                CountDownBoxView(text: "3").padding()
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.0)
                        let once = baseAnimation.repeatCount(1, autoreverses: false)
                        return withAnimation(once.delay(0.5)) {
                            self.scale = 0.0
                        }
                    }
                CountDownBoxView(text: "2").padding()
                    .scaleEffect(scale1)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.0)
                        let once = baseAnimation.repeatCount(1, autoreverses: false)
                        return withAnimation(once.delay(1.5)) {
                            self.scale1 = 0.0
                        }
                    }
                CountDownBoxView(text: "1").padding()
                    .scaleEffect(scale2)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.0)
                        let once = baseAnimation.repeatCount(1, autoreverses: false)
                        return withAnimation(once.delay(2.5)) {
                            self.scale2 = 0.0
                        }
                    }
                    .onAnimationCompleted(for: scale2, completion: {
                        self.showModal.toggle()
                    })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.0))
        }   
    }
}

struct CountDownBoxView: View {
    var text: String
    var body: some View {
        Text(text)
            .frame(width: 200, height: 200, alignment: .center)
            .font(.system(size: 72.0))
            .background(Rectangle()
                            .foregroundColor(.clear)
                            .cornerRadius(10.0)
                            .transition(.asymmetric(insertion: .scale, removal: .opacity)))
    }
}
