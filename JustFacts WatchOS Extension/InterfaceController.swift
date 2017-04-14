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
    var categories:Results<CategoryDataModel>?
    var selectedIndex = 0
    
    let realm = try! Realm()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let appGroup = "group.com.fruktorum.JustFacts"
        let fileManager = FileManager.default
        let realmConfigurator = AppGroupRealmConfiguration(appGroupIdentifier: appGroup, fileManager: fileManager)
        realmConfigurator.updateDefaultRealmConfiguration()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
            
            sendMessage()
        }
        self.allCategories()
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
        let realm = try! Realm()
        if let categoriesFromDB = realm.objects(CategoryDataModel.self) as? Results<CategoryDataModel> {
            self.categories = categoriesFromDB //запись категорий
            self.prepareTable()

            //realmLabel.setText(firstField.text)
        }
//        LibraryWatchAPI.sharedInstance().getAllCategoryForWatch ({ (categories: Results<CategoryDataModel>?) -> Void in
//            
//            if categories != nil {
//                    self.categories = categories //запись категорий
//                    self.prepareTable()
//            }
//        })
    }
    
    func prepareTable () {
        let categorienNumber = categories?.count
        
        categoryTable.setNumberOfRows(categorienNumber!, withRowType: "CategoryRow")
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
        print("ActivationDidComplete")
        
        let realm = try! Realm()
        if (realm.objects(CategoryDataModel.self) as? Results<CategoryDataModel>) == nil {
            print("БД пустая!")
            sendMessage()
        }
    }
    
    
    func sendMessage(){
        if WCSession.default().isReachable {
            let applicationDict = ["getCategories": 1]
            WCSession.default().sendMessage(applicationDict,
                                            replyHandler: {
                                                replyDict in print(replyDict)
                                                
                                                if let reply = replyDict as? [String:String], reply == ["reply" : "OK"] {
                                                    self.allCategories()
                                                }
                                                
            },
                                            errorHandler: {
                                                error in print(error.localizedDescription)
            })
        }
    }
}
