//
//  WKPersistencyManager.swift
//  JustStudio
//
//  Created by a1 on 23.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import UIKit

protocol WKPersistencyManager {
    func getCategoriesFromDB_ForWatch(_ completion: (_ data:Data?) -> Void)
    func getFactsFromDB_ForWatch(withCategory category: String, _ completion: (_ data:Data?) -> Void)
}

extension PersistencyManager: WKPersistencyManager {
    
    func getCategoriesFromDB_ForWatch(_ completion: (_ data:Data?) -> Void) {
        
        let resultReadCategoryFromDB = readCategoryFromBD()
        
        if resultReadCategoryFromDB != nil, (resultReadCategoryFromDB?.count)! > 0 {
            var result = [Category]()
            for elem in resultReadCategoryFromDB! {
                let category_obj = Category(elem._id, elem.active, elem.ru, elem.image, elem.en, elem.name, elem.image_view!)
                category_obj.image_view = nil
                result.append(category_obj)
            }
            
            NSKeyedArchiver.setClassName("Category", for: Category.self)
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: result) as NSData
            completion(archiveData as Data)
        } else {
            completion(nil)
        }
    }
    
    func getFactsFromDB_ForWatch(withCategory category: String, _ completion: (_ data:Data?) -> Void) {
        let resultReadFactsFromDB = readFactFromDB_ForWatch(category: category)
        
        if resultReadFactsFromDB != nil, (resultReadFactsFromDB?.count)! > 0 {
            var result = [Fact]()
            for elem in resultReadFactsFromDB! {
                let fact_obj = Fact(elem._id, elem.active, elem.ru, elem.image, elem.en, elem.category, elem.image_view!, elem.isLike)
                fact_obj.image_view = nil
                result.append(fact_obj)
            }
            
            NSKeyedArchiver.setClassName("Fact", for: Fact.self)
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: result) as NSData
            completion(archiveData as Data)
        } else {
            completion(nil)
        }
    }
}
