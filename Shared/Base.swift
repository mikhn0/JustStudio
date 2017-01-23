//
//  Base.swift
//  JustStudio
//
//  Created by a1 on 24.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class Base: NSObject {
    
    let _id: String
    let active: Bool
    let ru: String
    let en: String
    
    init(_ _id: String, _ active: Bool, _ ru: String, _ en: String) {
        self._id = _id
        self.active = active
        self.ru = ru
        self.en = en
    }
}
