//
//  KeyValueObserving.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 21.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

//IndicatorViewBehave


class MyObjectToObserve: NSObject {
   
    dynamic var myImage = UIImageView()
   
    func updateDate() {
        myImage = UIImageView()
    }
}


private var myContext = 0


class MyObserver: NSObject {
    var objectToObserve = MyObjectToObserve()
    override init() {
        super.init()
        objectToObserve.addObserver(self, forKeyPath: "myImage", options: .new, context: &myContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            if let newValue = change?[.newKey] {
              //  myActivityIndicator
                //print("Date changed: \(newValue)")
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        objectToObserve.removeObserver(self, forKeyPath: "myImage", context: &myContext)
    }
}










