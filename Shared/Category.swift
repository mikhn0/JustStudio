//
//  Flight.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class Category: Base {
  
    var image_mini: String
    var name: String
    
    init(_ _id: String, _ active: Bool, _ ru: String, _ image: String, _ en: String, _ name: String) {
        self.image_mini = image
        self.name = name
        super.init(_id, active, ru, en)
    }
  
    convenience init(category: [String: AnyObject]) {
        let id = category["_id"] as! String
        let active = category["active"] as! Bool
        let ru = category["ru"] as! String
        let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
        let image = urlWithService + (category["image"] as! String)
        let en = category["en"] as! String
        let name = category["name"] as! String
        
        self.init(id, active, ru, image, en, name)
    }

}
