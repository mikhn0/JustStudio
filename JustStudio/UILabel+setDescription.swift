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
        text = returnDescriptionForApp(dataObject)
    }
}

func returnDescriptionForApp(_ dataObject: BaseDataModel) -> String {
    let pre = NSLocale.preferredLanguages[0]
    return pre.contains("ru") ? dataObject.ru : dataObject.en
}


