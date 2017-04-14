//
//  CategoryDataModel.swift
//  JustStudio
//
//  Created by Виктория on 04.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import WatchKit


class CategoryDataModel: BaseDataModel {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var image: String = ""
    dynamic var name: String = ""
    let listOfFacts = List<FactDataModel>()
    dynamic var last_show = Date(timeIntervalSinceNow: -86400)
}