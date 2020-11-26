//
//  AppDelegate.swift
//  Simple Timer
//
//  Created by Nathan Hoellein on 8/1/20.
//  Copyright © 2020 4BitShift. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let sound = Bundle.main.url(forResource: "CountDown", withExtension: "mp3") {
            let didLoad = AudioServicesCreateSystemSoundID(sound as CFURL, &Sounds.countDown)
            
            if didLoad != 0 {
                print("Error creating system sound")
            }
        } else {
            print("No file")
        }
        
        if let sound = Bundle.main.url(forResource: "StartSound", withExtension: "mp3") {
            let didLoad = AudioServicesCreateSystemSoundID(sound as CFURL, &Sounds.start)
            
            if didLoad != 0 {
                print("Error creating system sound")
            }
        } else {
            print("no file")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
