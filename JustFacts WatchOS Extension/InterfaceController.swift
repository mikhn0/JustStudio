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

    //var categories: Results<CategoryDataModel>?
    var categoriesFromApp: [Category] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        invalidateUserActivity()
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
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
        
        sendMessageForFacts(index: selectedIndex)
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

//    func allCategories(categories:[Category]) {
//
//        LibraryWatchAPI.sharedInstance().getAllCategoryForWatch ({ (categories: Results<CategoryDataModel>?) -> Void in
//            if categories != nil {
//                    self.categories = categories //запись категорий
//                    self.prepareTable()
//            }
//        })
//    }
    
    func prepareTable () {
        let categoryNumber = categoriesFromApp.count
        categoryTable.setNumberOfRows(categoryNumber, withRowType: "CategoryRow")
        
        for index in 0..<categoryTable.numberOfRows {
            if let controller = categoryTable.rowController(at: index) as? CategoryRowController {
                controller.category = categoriesFromApp[index]
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
        sendMessageForCategories()
        
    }

    func sendMessageForCategories() {
        if WCSession.default().isReachable {
            let applicationDict = ["getCategoriesFromDB": 1]
            WCSession.default().sendMessage(applicationDict,
                                            replyHandler: { replyDict in print(replyDict)
                                                let reply = replyDict["reply"]
                                                print("!!!! reply from App_1 === \(reply!)")
                                            },
                                            errorHandler: { error in print(error.localizedDescription) })
        }
    }

    func sendMessageForFacts(index: Int) {
        if WCSession.default().isReachable {
            let applicationDict = ["getFactsFromDB": self.categoriesFromApp[index].name]
            WCSession.default().sendMessage(applicationDict,
                                            replyHandler: { replyDict in print(replyDict)
                                                let reply = replyDict["reply"]
                                                print("!!!! reply from App_2 === \(reply!)") },
                                            errorHandler: { error in print(error.localizedDescription) })
        }
    }
    
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("Get categories from DB")
        print("message = \(messageData)")
        NSKeyedUnarchiver.setClass(Category.self, forClassName: "Category")
        let categoriesFromApp = NSKeyedUnarchiver.unarchiveObject(with: messageData) as! [Category]
        print("\(categoriesFromApp)")
        self.categoriesFromApp = categoriesFromApp
        self.prepareTable()
        
        print("")
        
        
        
    }
    
}
