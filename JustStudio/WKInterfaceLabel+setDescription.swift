//
//  WKInterfaceLabel+setDescription.swift
//  JustStudio
//
//  Created by a1 on 24.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import WatchKit

extension WKInterfaceLabel {
    func setDescription(dataObject: Base) {
        
        let pre = NSLocale.preferredLanguages[0]
        
        if pre.contains("ru") {
            self.setText(dataObject.ru)
        } else {
            self.setText(dataObject.en)
        }
    }
    
}
