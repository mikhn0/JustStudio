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
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    var realm: Realm!
    var wcSession: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appGroup = "group.com.fruktorum.JustFacts"
        let fileManager = FileManager.default
        let realmConfigurator = AppGroupRealmConfiguration(appGroupIdentifier: appGroup, fileManager: fileManager)
        realmConfigurator.updateDefaultRealmConfiguration()
        
        print("!!!!fileDBonApp ===== \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {  
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        return true
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    

    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("ActivationDidComplete on iPhone")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if let messCateg = message["getCategoriesFromDB"] as! String?, messCateg == "1" {
            LibraryAPI.sharedInstance().getCategoriesFromDB_ForWatch({data in
                if data != nil {
                    replyHandler(["reply" : "Category"])
                    session.sendMessageData(data!,
                                            replyHandler: nil,
                                            errorHandler: nil)
                } else {
                    replyHandler(["reply" : "Category_Error"])
                }
            })
        } else {
            let messFact = message["getFactsFromDB"] as! String? 
            LibraryAPI.sharedInstance().getFactsFromDB_ForWatch(withCategory: messFact!, {data in
                if data != nil {
                    replyHandler(["reply" : "Fact"])
                    session.sendMessageData(data!,
                                            replyHandler: nil,
                                            errorHandler: nil)
                } else {
                    replyHandler(["reply" : "Fact_Error"])
                }
            })
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

}

