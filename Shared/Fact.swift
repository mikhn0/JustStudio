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
    var isLike : Bool = false
    
    init(_ id:String!,_ active:Bool!,_ ru:String!,_ image: String!,_ en:String!,_ category:String!, _ image_view:NSData, _ isLike:Bool) {
        super.init(id, active, ru, en, image_view)
        self.image = image
        self.category = category
        self.isLike = isLike
    }
    
    convenience init(fact: [String: AnyObject]) {
        let id = fact["_id"] as! String
        let active = fact["active"] as! Bool
        let ru = fact["ru"] as! String
        let image = fact["image"] as! String
        let en = fact["en"] as! String
        let category = fact["category"] as! String
        let image_view = fact["image_view"] as! NSData
        let isLike = fact["isLike"] as! Bool
        self.init(id, active, ru, image, en, category, image_view, isLike)
    }
    
    convenience init(withRealm fact:FactDataModel) {
        let id = fact._id
        let active = fact.active
        let ru = fact.ru
        let image = fact.image
        let en = fact.en
        let category = fact.category
        let image_view = fact.image_view
        let isLike = fact.isLike
        self.init(id, active, ru, image, en, category, image_view!, isLike)
    }
    
    required init?(coder aDecoder: NSCoder) {
        image = aDecoder.decodeObject(forKey: "image") as! String
        category = aDecoder.decodeObject(forKey: "category") as! String
        isLike = aDecoder.decodeBool(forKey: "isLike")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(image, forKey: "image")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(active, forKey: "isLike")
    }
}
