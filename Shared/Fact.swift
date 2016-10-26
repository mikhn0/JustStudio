//
//  Fact.swift
//  JustStudio
//
//  Created by Виктория on 10.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class Fact: Base {
    var image: String!
    var category : String!
    
    
    init(id:String!, active:Bool!, ru:String!, image: String!, en:String!, category:String!) {
        super.init(_id: id, active: active, ru: ru, en: en)
        self.image = image
        self.category = category
        
    }
    
    convenience init(category: [String: AnyObject]) {
        let id = category["_id"]!
        let active = category["active"]!
        let ru = category["ru"]!
        let image = category["image"]!
        let en = category["en"]!
        let category = category["category"]!
        
        
        self.init(id: id as! String, active: active as! Bool, ru: ru as! String, image: image as! String, en: en as! String, category: category as! String)
    }
}
