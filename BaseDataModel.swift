//
//  BaseDataModel.swift
//  JustStudio
//
//  Created by Виктория on 04.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift

class BaseDataModel: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var _id: String = ""
    dynamic var active: Bool = false
    dynamic var ru: String = ""
    dynamic var en: String = ""
    dynamic var image_view: NSData?
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}

