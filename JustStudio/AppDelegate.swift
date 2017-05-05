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
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    var realm: Realm!
    var wcSession: WCSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let appGroup = "group.com.fruktorum.JustFacts"
        let fileManager = FileManager.default
        let realmConfigurator = AppGroupRealmConfiguration(appGroupIdentifier: appGroup, fileManager: fileManager)
        realmConfigurator.updateDefaultRealmConfiguration()
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        return true
    }

    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("ActivationDidComplete on iPhone")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if let messCateg = message["getCategoriesFromDB"] as! Int?, messCateg == 1 {
            LibraryAPI.sharedInstance().recieveCategoriesFromServer({data in
                session.sendMessageData(data as Data,
                                        replyHandler: nil,
                                        errorHandler: nil)
                replyHandler(["reply" : "Category_OK"])
            })
        }
        if let messFact = message["getFactsFromDB"] as! String? {
            LibraryAPI.sharedInstance().receiveFactsFromServer(messFact, {data in
                session.sendMessageData(data as Data,
                                        replyHandler: nil,
                                        errorHandler: nil)
                replyHandler(["reply" : "Fact_OK"])
            })
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

}

