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
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    static let API_key = "abae5e67-a952-4261-96bf-7630f6efc3db"
    var window: UIWindow?
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
        
        catchEvent(withText: "ACTIVE_APP")
        
        return true
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
    
    override class func initialize() {
        if self === AppDelegate.self {
        //Инициализация AppMetrica SDK
            let configuration = YMMYandexMetricaConfiguration.init(apiKey: API_key)
            let isFirstApplicationLaunch = false
            // Передайте значение true, если не хотите, чтобы данный пользователь засчитывался как новый
            configuration?.handleFirstActivationAsUpdateEnabled = isFirstApplicationLaunch == false
            // Инициализация AppMetrica SDK
            YMMYandexMetrica.activate(with: configuration!)
        }
    }
}
