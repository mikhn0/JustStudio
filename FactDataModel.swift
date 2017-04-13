//
//  FactDataModel.swift
//  JustStudio
//
//  Created by Виктория on 04.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift

class FactDataModel: BaseDataModel {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
 
    dynamic var image: String! = nil
    dynamic var category : String! = nil
    dynamic var selectCategory: CategoryDataModel?
}
