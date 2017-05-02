//
//  InterfaceController.swift
//  JustFacts WatchOS Extension
//
//  Created by Виктория on 16.09.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift
import Realm
import WatchConnectivity

class InterfaceController: WKInterfaceController , WCSessionDelegate {

    @IBOutlet var backgroundGroup: WKInterfaceGroup!
    @IBOutlet var categoryTable: WKInterfaceTable!

    var selectedIndex = 0
    var realm: Realm!

    var categories: Results<CategoryDataModel>?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        //self.prepareTable()
    }
    
    override func didAppear() {
        super.didAppear()
        if let controller = categoryTable.rowController(at: selectedIndex) as? CategoryRowController {
            animate(withDuration: 0.35, animations: { () -> Void in
                controller.updateForCheckIn()
            })
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        selectedIndex = rowIndex
        print("start press on cell")
        
        startAnim()
        
        LibraryWatchAPI.sharedInstance().getFactsByCategoryForWatch ( (categories?[rowIndex].name)! , completion:{ (facts: [Fact]) -> Void in
 
            var contexts: [Fact] = []
            var controllers:  [String] = []
            
            var factNumbers = 20
            if facts.count < factNumbers {
                factNumbers = facts.count
            }
            
            for index in 0..<factNumbers {
                contexts.append(facts[index])
                controllers.append("FactsController")
            }


            self.presentController(withNames: controllers, contexts:  contexts);
            self.stopAnim()
        })
    }

    func allCategories() {

        LibraryWatchAPI.sharedInstance().getAllCategoryForWatch ({ (categories: Results<CategoryDataModel>?) -> Void in
            if categories != nil {
                    self.categories = categories //запись категорий
                    self.prepareTable()
            }
        })
    }
    
    func prepareTable () {
        let categoryNumber = categories?.count
        
        categoryTable.setNumberOfRows(categoryNumber!, withRowType: "CategoryRow")
        for index in 0..<categoryTable.numberOfRows {
            if let controller = categoryTable.rowController(at: index) as? CategoryRowController {
                
                controller.category = categories?[index]
                if index == categoryTable.numberOfRows-1 {
                    self.stopAnim()
                }
            }
        }
    }
    
    func startAnim() {
        backgroundGroup.startAnimating()
        backgroundGroup.setHidden(false)
    }
    
    func stopAnim() {
        backgroundGroup.stopAnimating()
        backgroundGroup.setHidden(true)
    }
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("ActivationDidComplete on Watch")
        
        sendMessage()

        
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
//        print("receiveFile === \(file.fileURL)")
//        var config = Realm.Configuration()
//        config.fileURL = file.fileURL
//        Realm.Configuration.defaultConfiguration = config
//        print("fileURL === \(Realm.Configuration.defaultConfiguration))")
        
        
    }

//    func recieveFileDB() {
//        if WCSession.default().isReachable {
//            let applicationDict = ["getFileDB": 1]
//            WCSession.default().sendMessage(applicationDict,
//                                            replyHandler: {
//                                                replyDict in print(replyDict)
//            },
//                                            errorHandler: {
//                                                error in print(error.localizedDescription)
//            })
//        }
//    }
    func sendMessage() {
        if WCSession.default().isReachable {
            let applicationDict = ["getCategories": 1]
            WCSession.default().sendMessage(applicationDict,
                                            replyHandler: { replyDict in print(replyDict)
                                                let fileDB_URL = replyDict["reply"]
                                                print("!!!! fileDB_URL from App === \(fileDB_URL!)")
                                                
                                                let appGroup = "group.com.fruktorum.JustFacts"
                                                let fileManager = FileManager.default
                                                let realmConfigurator = AppGroupRealmConfiguration(appGroupIdentifier: appGroup, fileManager: fileManager)
                                                realmConfigurator.setPhoneRealmConfiguration(withPath: URL(fileURLWithPath: fileDB_URL as! String))//(fileDB_URL as! String))
                                                //print("fileURL === \(Realm.Configuration.defaultConfiguration))")

                                                
            },
                                            
                                                
//                                                if let reply = replyDict as? [String:String], reply["reply"] == "OK" {
//                                                    self.allCategories()
//                                                }

                                            errorHandler: { error in print(error.localizedDescription) })
        }
    }
}
