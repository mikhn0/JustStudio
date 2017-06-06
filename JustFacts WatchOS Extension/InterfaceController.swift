//
//  InterfaceController.swift
//  JustFacts WatchOS Extension
//
//  Created by Виктория on 16.09.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

enum TypeMessageData {
    case Category
    case Fact
    
    mutating func detectType(byReply reply:String) {
        if reply == "Category" {
            self = .Category
        } else if reply == "Fact" {
            self = .Fact
        }
    }
}

class InterfaceController: WKInterfaceController , WCSessionDelegate {

    @IBOutlet var backgroundGroup: WKInterfaceGroup!
    @IBOutlet var categoryTable: WKInterfaceTable!

    var selectedIndex = 0
    var typeMessageData:TypeMessageData = .Category
    
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
        categoryTable.setHidden(false)
        if let controller = categoryTable.rowController(at: selectedIndex) as? CategoryRowController {
            animate(withDuration: 0.35, animations: { () -> Void in
                controller.updateForCheckIn()
            })
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        selectedIndex = rowIndex
        startAnim()
        categoryTable.setHidden(true)
        sendMessageForFacts(index: selectedIndex)
    }
    
    func prepareTable () {
        categoryTable.setHidden(false)
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
    
    func prepareFacts(facts: [Fact]) {
        var contexts: [Fact] = []
        var controllers:  [String] = []
        
        let factNumbers = facts.count
        
        for index in 0..<factNumbers {
            contexts.append(facts[index])
            controllers.append("FactsController")
        }
        
        self.presentController(withNames: controllers, contexts:  contexts);
        self.stopAnim()
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

    func sendMessage() {
        if WCSession.default().isReachable {
            let applicationDict = ["getCategoriesFromDB": "1"]
            WCSession.default().sendMessage(applicationDict,
                                            replyHandler: { replyDict in print(replyDict)
                                                let reply = replyDict["reply"] as! String
                                                if reply == "Category_Error" {
                                                    let action = WKAlertAction(title: "OK", style: .default, handler:{})
                                                    
                                                    let warning = "NO CATEGORY! DB IS EMPTY!!!"
                                                    self.presentAlert(withTitle: warning, message: "", preferredStyle: .actionSheet, actions: [action])
                                                    
//                                                    let warning = SystemWarningForWatch.init()
//                                                    self.presentAlert(withTitle: detectCurrentLang(warning), message: "", preferredStyle: .actionSheet, actions: [action])
//                                                    self.sendMessage()
                                                }
                                            },
                                            errorHandler: { error in print(error.localizedDescription) })
        }
        self.typeMessageData.detectType(byReply: "Category")
    }

    func sendMessageForFacts(index: Int) {
        if WCSession.default().isReachable {
            let applicationDict = ["getFactsFromDB": self.categoriesFromApp[index].name]
            WCSession.default().sendMessage(applicationDict,
                                            replyHandler: { replyDict in print(replyDict)
                                                let reply = replyDict["reply"] as! String
                                                if reply == "Fact_Error" {
                                                    let action = WKAlertAction(title: "OK", style: .default, handler:{})
                                                    let warning = SystemWarningForWatch()
                                                    self.presentAlert(withTitle: detectCurrentLang(warning), message: "", preferredStyle: .actionSheet, actions: [action])
                                                }
                                            },
                                            errorHandler: { error in print(error.localizedDescription) })
        }
        self.typeMessageData.detectType(byReply: "Fact")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        switch typeMessageData {
        case .Category:
            NSKeyedUnarchiver.setClass(Category.self, forClassName: "Category")
            let categoriesFromApp = NSKeyedUnarchiver.unarchiveObject(with: messageData) as! [Category]
            print("\(categoriesFromApp)")
            self.categoriesFromApp = categoriesFromApp
            self.prepareTable()
        case .Fact :
            NSKeyedUnarchiver.setClass(Fact.self, forClassName: "Fact")
            let factsFromApp = NSKeyedUnarchiver.unarchiveObject(with: messageData) as! [Fact]
            print("\(factsFromApp)")
            prepareFacts(facts: factsFromApp)
        }
    }
    
}
