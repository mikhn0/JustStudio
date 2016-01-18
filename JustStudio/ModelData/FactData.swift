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
    var facts : String!
    var language : String!
    var image_url : String!
    
    init(id:String, facts:String, language:String, image_url:String) {
        super.init()
        self.id = id
        self.facts = facts
        self.language = language
        self.image_url = image_url
    }
}

