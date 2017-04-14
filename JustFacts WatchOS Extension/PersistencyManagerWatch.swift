//
//  PersistencyManagerWatch.swift
//  JustStudio
//
//  Created by Виктория on 14.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PersistencyManagerWatch: NSObject {
    
    let realm = try! Realm()
    
    func readCategoryFromBD() -> Results<CategoryDataModel>? {
        return realm.objects(CategoryDataModel.self)
    }
    
}
