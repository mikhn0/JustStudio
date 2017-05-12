//
//  Base.swift
//  JustStudio
//
//  Created by a1 on 24.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class Base:NSObject, NSCoding {
    
    var _id: String
    var active: Bool
    var ru: String
    var en: String
    var image_view: NSData?
    
    init(_ _id: String, _ active: Bool, _ ru: String, _ en: String, _ image_view: NSData?) {
        self._id = _id
        self.active = active
        self.ru = ru
        self.en = en
        self.image_view = image_view
    }
 
    required init?(coder aDecoder: NSCoder) {
        _id = aDecoder.decodeObject(forKey: "_id") as! String
        active = aDecoder.decodeBool(forKey: "active")
        ru = aDecoder.decodeObject(forKey: "ru") as! String
        en = aDecoder.decodeObject(forKey: "en") as! String
        image_view = aDecoder.decodeObject(forKey: "image_view") as? NSData
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
        aCoder.encode(active, forKey: "active")
        aCoder.encode(ru, forKey: "ru")
        aCoder.encode(en, forKey: "en")
        aCoder.encode(image_view, forKey: "image_view")
    }
    
}


class SystemWarningForWatch: Base {
  
    init(ru:String, en:String) {
        super.init("", true, ru, en, nil)
    }
    
    convenience init() {
        self.init(ru: "Для того, что бы просмотреть данную категорию, откройте eё сначала на телефоне.",
                  en: "To view this category, please open it firstly in your iphone app.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
