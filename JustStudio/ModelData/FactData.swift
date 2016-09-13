//
//  FactData.swift
//  JustStudio
//
//  Created by Imac on 21.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation

class FactData: NSObject {
    var id : String!
    var active : Bool!
    var category : String!
    var en : String!
    var ru : String!
    var image_url : String!
    
    init(id:String!, active:Bool!, category:String!, en:String!, ru:String!, image_url:String!) {
        super.init()
        self.id = id
        self.active = active
        self.category = category
        self.en = en
        self.ru = ru
        self.image_url = image_url
    }
}

