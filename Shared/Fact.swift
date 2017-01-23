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
    
    
    init(_ id:String!,_ active:Bool!,_ ru:String!,_ image: String!,_ en:String!,_ category:String!) {
        super.init(id, active, ru, en)
        self.image = image
        self.category = category
    }
    
    convenience init(fact: [String: AnyObject]) {
        let id = fact["_id"] as! String
        let active = fact["active"] as! Bool
        let ru = fact["ru"] as! String
        let image = fact["image"] as! String
        let en = fact["en"] as! String
        let category = fact["category"] as! String
        
        self.init(id, active, ru, image, en, category)
    }
}
