////
////  WatchSessionManager.swift
////  JustStudio
////
////  Created by Виктория on 14.04.17.
////  Copyright © 2017 Imac. All rights reserved.
////
//
//import Foundation
//import WatchConnectivity
//
//// Note that the WCSessionDelegate must be an NSObject
//// So no, you cannot use the nice Swift struct here!
//class WatchSessionManager: NSObject, WCSessionDelegate {
//    
//    // Instantiate the Singleton
//    static let sharedManager = WatchSessionManager()
//    private override init() {
//        super.init()
//    }
//    
//    // Keep a reference for the session,
//    // which will be used later for sending / receiving data
//    private let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
//    var validSession: WCSession? {
//        
//        // paired - the user has to have their device paired to the watch
//        // watchAppInstalled - the user must have your watch app installed
//        
//        // Note: if the device is paired, but your watch app is not installed
//        // consider prompting the user to install it for a better experience
//        
//        if let session = session, session.isPaired && session.isWatchAppInstalled {
//            return session
//        }
//        return nil
//    }
//    // Activate Session
//    // This needs to be called to activate the session before first use!
//    func startSession() {
//        session?.delegate = self
//        session?.activate()
//    }
//    
//    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        
//    }
//    
//}
//
//extension WatchSessionManager {
//    
//    // Sender
//    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
//        if let session = validSession {
//            do {
//                try session.updateApplicationContext(applicationContext)
//            } catch let error {
//                throw error
//            }
//        }
//    }
//    
//    // Receiver
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        // handle receiving application context
//        
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//}
//
//// MARK: User Info
//// use when your app needs all the data
//// FIFO queue
//extension WatchSessionManager {
//    
//    // Sender
//    func transferUserInfo(userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
//        return validSession?.transferUserInfo(userInfo)
//    }
//    
//    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
//        // implement this on the sender if you need to confirm that
//        // the user info did in fact transfer
//    }
//    
//    // Receiver
//    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
//        // handle receiving user info
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//    
//}
//
//// MARK: Transfer File
//extension WatchSessionManager {
//    
//    // Sender
//    func transferFile(file: NSURL, metadata: [String : AnyObject]) -> WCSessionFileTransfer? {
//        return validSession?.transferFile(file as URL, metadata: metadata)
//    }
//    
//    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?) {
//        // handle filed transfer completion
//    }
//    
//    // Receiver
//    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
//        // handle receiving file
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//}
//
//
//// MARK: Interactive Messaging
//extension WatchSessionManager {
//    
//    // Live messaging! App has to be reachable
//    private var validReachableSession: WCSession? {
//        if let session = validSession, session.isReachable {
//            return session
//        }
//        return nil
//    }
//    
//    // Sender
//    func sendMessage(message: [String : AnyObject],
//                     replyHandler: (([String : Any]) -> Void)? = nil,
//                     errorHandler: ((NSError) -> Void)? = nil)
//    {
//        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler as? (Error) -> Void)
//    }
//    
//    func sendMessageData(data: NSData,
//                         replyHandler: ((Data) -> Void)? = nil,
//                         errorHandler: ((NSError) -> Void)? = nil)
//    {
//        validReachableSession?.sendMessageData(data as Data, replyHandler: replyHandler, errorHandler: errorHandler as? (Error) -> Void)
//    }
//    
//    // Receiver
//    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
//        // handle receiving message
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//    
//    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
//        // handle receiving message data
//        DispatchQueue.main.async() {
//            // make sure to put on the main queue to update UI!
//        }
//    }
//}
