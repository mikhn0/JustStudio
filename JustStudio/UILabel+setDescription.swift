//
//  UILabel+setDescription.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 20.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

extension UILabel {
    func setDescription(dataObject: BaseDataModel) {
        
        let pre = NSLocale.preferredLanguages[0]
        
        if pre.contains("ru") {
            self.text = dataObject.ru
        } else {
            self.text = dataObject.en
        }
    }
    
    class func returnDescription(dataObject: BaseDataModel) -> String {
        let pre = NSLocale.preferredLanguages[0]
        if pre.contains("ru") {
            return dataObject.ru
        } else {
            return dataObject.en
        }
    }
    
}


