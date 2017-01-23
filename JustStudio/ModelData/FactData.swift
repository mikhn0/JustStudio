//
//  FactData.swift
//  JustStudio
//
//  Created by Imac on 21.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation

class FactData: BaseData {
    
    var category : String!
    var image : UIImage?// = UIImage(named:"tree_background")
    
    init(_ id:String!, _ active:Bool!, _ category:String!, _ en:String!, _ ru:String!, _ image_url:String!) {
        super.init(id, ru, en, active, image_url)
        self.category = category
    }
    
    convenience init(fact: [String: AnyObject]) {
        let id = fact["_id"] as! String
        let active = fact["active"] as! Bool
        let ru = fact["ru"] as! String
        let image = fact["image"] as! String
        let en = fact["en"] as! String
        let category = fact["category"] as! String
        
        self.init(id, active, category, en, ru, image)
    }
}
