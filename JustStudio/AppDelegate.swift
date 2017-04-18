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
        
        //let pathFile = Realm.Configuration.defaultConfiguration.fileURL! as URL
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
            //wcSession?.transferFile(pathFile, metadata: nil)
        }
        return true
    }

    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("ActivationDidComplete on iPhone")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if let mess = message["getCategories"] as! Int?, mess == 1 {
            let path = Realm.Configuration.defaultConfiguration.fileURL! as URL
            
            replyHandler(["reply" : "\(path)"])
            
            
        }
        
//        if let command = message["getFileDB"] as! Int?, command == 1 {
//            replyHandler(["reply" : "transferFileOK"])
//            DispatchQueue.main.async {
//                if let path = Realm.Configuration().fileURL {
//                    WCSession.default().transferFile(path, metadata: nil)
//                   // replyHandler(["reply" : "transferFileOK"])
//                    
//                }
//            }
//        } else if let command = message["getCategories"] as! Int?, command == 1 {
//            replyHandler(["reply" : "OK"])
//            //запрос на сервер с загрузкой данных в бд
////            LibraryAPI.sharedInstance().recieveCategoriesFromServer({ (reply: [String : String]) in
////                replyHandler(reply)
////            })
//        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

}

