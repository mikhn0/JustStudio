//
//  AppDelegate.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import UIKit
import RealmSwift
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appGroup = "group.com.fruktorum.JustFacts"
        let fileManager = FileManager.default
        let realmConfigurator = AppGroupRealmConfiguration(appGroupIdentifier: appGroup, fileManager: fileManager)
        realmConfigurator.updateDefaultRealmConfiguration()
        
//        WatchSessionManager.sharedManager.startSession()
    
        // Override point for customization after application launch.
        return true
    }

//    func sessionReachabilityDidChange(session: WCSession) {
//        // handle session reachability change
//        if session.isReachable {
//            print("great! continue on with Interactive Messaging")
//            // great! continue on with Interactive Messaging
//        } else {
//            print("😥 prompt the user to unlock their iOS device")
//            // 😥 prompt the user to unlock their iOS device
//        }
//    }
}

