//
//  PerssistencyManager.swift
//  JustStudio
//
//  Created by Виктория on 06.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class PersistencyManager {
    
    let realm = try! Realm()

    func readCategoryFromBD() -> Results<CategoryDataModel>? {
        return realm.objects(CategoryDataModel.self)
    }
    
    func readFactFromBD(category: CategoryDataModel) -> Results<FactDataModel>? {
        let aPredicate = NSPredicate(format: "selectCategory = %@", category)
        return realm.objects(FactDataModel.self).filter(aPredicate)
    }
    
    func readRandomFactFromDB(random: String) -> Results<FactDataModel>? {
        let aPredicate = NSPredicate(format: "random = %@", random)
        return realm.objects(FactDataModel.self).filter(aPredicate)
    }
    
    func readFactFromDB_ForWatch(category: String) -> Results<FactDataModel>? {
        let aPredicate = NSPredicate(format: "selectCategory.name = %@", category)
        return realm.objects(FactDataModel.self).filter(aPredicate)
    }
    
    func writeCategoriesToBD(categories: [AnyObject], _ completion: @autoclosure @escaping () -> Void) {
        
        for element in categories {
            let dict = element as! [String : AnyObject]
            let categoryData = CategoryDataModel(value: dict)
            
            try! self.realm.write {
                self.realm.add(categoryData, update:true)
            }
            
            let categoryRef = ThreadSafeReference(to: categoryData)
            
            DispatchQueue(label: ".RealmThreadForCategories\(categoryData._id)").async {
                
                let realm = try! Realm()
                guard let categ = realm.resolve(categoryRef) else {
                    return // person was deleted
                }
                let imageData = try? Data(contentsOf: URL(string: categ.image)!)
                try! realm.write {
                    if imageData != nil {
                        categ.image_view = imageData! as NSData
                    }
                }
            }
        }
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func writeFactsToBD(selectCategory: CategoryDataModel, facts: [AnyObject], _ completion: @autoclosure @escaping () -> Void) {
        
        for element in facts {
            let dict = element as! [String : AnyObject]
            let factData = FactDataModel(value: dict)
            factData.selectCategory = selectCategory //установка отношения многие к одному
            
            try! self.realm.write {
                self.realm.add(factData, update: true)
            }
            
            let factRef = ThreadSafeReference(to: factData)
            
            let urlService = URL(string: factData.image)
            
            let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                if error == nil {
                    let realm = try! Realm()
                    guard let fact = realm.resolve(factRef) else {
                        return
                    }
                    try! realm.write {
                        if data != nil {
                            fact.image_view = data! as NSData
                        }
                    }
                }
            })
            task.resume()
        }
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func writeRandomFactsToDB(random: String, randomFacts: [FactDataModel], _ completion: @autoclosure @escaping () -> Void) {
        DispatchQueue.main.async {
            for element in randomFacts {
                element.active = true
                element.image_view = nil
                element.selectCategory = nil
                element.isLike = false
                element.random = random //установка пометки рандомного факта
                let dict = element
                let factData = FactDataModel(value: dict)
                
                try! self.realm.write {
                    self.realm.add(factData, update: true)
                }
                
                let factRef = ThreadSafeReference(to: factData)
                
                let urlService = URL(string: factData.image)
                
                let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let realm = try! Realm()
                        guard let fact = realm.resolve(factRef) else {
                            return
                        }
                        try! realm.write {
                            if data != nil {
                                fact.image_view = data! as NSData
                            }
                        }
                    }
                })
                task.resume()
            }
        }
        DispatchQueue.main.async {
            completion()
        }
    }

    
}
