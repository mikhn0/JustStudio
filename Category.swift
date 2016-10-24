//
//  Flight.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class Category {
  
  let _id: String
  let active: Bool
  let ru: String
  let image_mini: String
  let en: String
  let name: String
    
  
  init(_id: String, active: Bool, ru: String, image: String, en: String, name: String) {
    self._id = _id
    self.active = active
    self.ru = ru
    self.image_mini = image
    self.en = en
    self.name = name
  }
  
  convenience init(category: [String: AnyObject]) {
    let id = category["_id"]!
    let active = category["active"]!
    let ru = category["ru"]!
    let image = category["image_mini"]!
    let en = category["en"]!
    let name = category["name"]!
    
    
    self.init(_id: id as! String, active: active as! Bool, ru: ru as! String, image: image as! String, en: en as! String, name: name as! String)
    }

}
