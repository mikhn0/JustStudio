//
//  Flight.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

//import WatchKit

class Category: Base {
  
    var image_mini: String
    var name: String
    
    init(_ _id: String, _ active: Bool, _ ru: String, _ image: String, _ en: String, _ name: String, _ image_view: NSData) {
        self.image_mini = image
        self.name = name
        super.init(_id, active, ru, en, image_view)
    }
  
    convenience init(category: [String: AnyObject]) {
        let id = category["_id"] as! String
        let active = category["active"] as! Bool
        let ru = category["ru"] as! String
        let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
        let image = urlWithService + (category["image"] as! String)
        let en = category["en"] as! String
        let name = category["name"] as! String
        let image_view = category["image_view"] as! NSData
        self.init(id, active, ru, image, en, name, image_view)
    }
    
    convenience init(withRealm category:CategoryDataModel) {
        let id = category._id
        let active = category.active
        let ru = category.ru
        let image = category.image
        let en = category.en
        let name = category.name
        let image_view = category.image_view
        self.init(id, active, ru, image, en, name, image_view!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        image_mini = aDecoder.decodeObject(forKey: "image_mini") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(image_mini, forKey: "image_mini")
        aCoder.encode(name, forKey: "name")
    }
}
