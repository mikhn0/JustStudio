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
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    static let API_key = "abae5e67-a952-4261-96bf-7630f6efc3db"
    var window: UIWindow?
    var wcSession: WCSession?
    
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
    }
    
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
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()

        catchEvent(withText: "ACTIVE_APP")
        
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
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("!!!!!!!!!!!!")
        
        return true
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        switch application.applicationState {
        case .active:
            //app is currently active, can update badges count here Приложение активно, обновите количество значков
            print("!!!! active")
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here Приложение переходит из фонового режима на передний план (уведомление пользователя о кранах), делайте то, что вам нужно, когда пользователь нажимает здесь
            incrementBadgeNumberBy(badgeNumberIncrement: -1)
            print("переход в приложение (-1) = \(UIApplication.shared.applicationIconBadgeNumber)")
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here Приложение находится в фоновом режиме, если доступный для содержимого ключ вашего уведомления установлен в 1, опрос на ваш сервер для извлечения данных и обновления вашего интерфейса здесь
            print("opened from a push notification when the app was on background")
            incrementBadgeNumberBy(badgeNumberIncrement: +1)
            print("находимся в background (+1) = \(UIApplication.shared.applicationIconBadgeNumber)")
            break
        }
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


func catchError(withText error: Error) {
    YMMYandexMetrica.reportError("ERROR_\(String(describing: error))", exception: nil) { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
    }
}

func catchEvent(withText text: String) {
    YMMYandexMetrica.reportEvent(text) { (error) in
        print("DID FAIL REPORT EVENT: %@", text)
        print("REPORT ERROR: %@", error.localizedDescription)
    }
}
