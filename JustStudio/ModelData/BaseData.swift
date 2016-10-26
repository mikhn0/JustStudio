//
//  BaseData.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 20.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class BaseData: NSObject {
    var id : String!
    var ru: String!
    var en: String!
    var active : Bool!
    var image_url : String!
    
    init(id:String!, ru:String!, en:String!, active:Bool!, image_url:String!) {
        super.init()
        self.id = id
        self.ru = ru
        self.en = en
        self.active = active
        self.image_url = image_url
    }
}
