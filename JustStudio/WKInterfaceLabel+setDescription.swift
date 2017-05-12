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
        self.setText(detectCurrentLang(dataObject))
    }
}

func detectCurrentLang(_ dataObject: Base) -> String {
    let pre = NSLocale.preferredLanguages[0]
    return pre.contains("ru") ? dataObject.ru : dataObject.en
}
