//
//  LibraryAPI.swift
//  JustStudio
//
//  Created by Imac on 18.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

let SERVER_URL:NSString = "http://13.91.106.16:5793/"


class LibraryAPI : NSObject  {
    
    let persistencyManager: PersistencyManager
    let httpClient: HTTPClient
    let isOnline: Bool
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = true
        super.init()
    }
    
    
    lazy var categoryArray: Results<CategoryDataModel> = {
        DispatchQueue.main.sync {
            let realm = try! Realm()
            return realm.objects(CategoryDataModel.self)
        }
    }()
    
    static var instance: LibraryAPI!
    
    class func sharedInstance() -> LibraryAPI {
        self.instance = (self.instance ?? LibraryAPI())
        return self.instance
    }
    
    func getAllCategory(_ completion: @escaping (_ categories:  Results<CategoryDataModel>? ) -> Void) {
        
        //1 get categories from BD
        if let categoriesFromDB = self.persistencyManager.readCategoryFromBD(), categoriesFromDB.count > 0 {
            completion(categoriesFromDB)
        }
        if isOnline {
            //2 request from Server all categories
            httpClient.getCategoriesFromServer() { (_ categories: [AnyObject]) -> Void in
                self.persistencyManager.writeCategoriesToBD(categories: categories, completion(self.persistencyManager.readCategoryFromBD()!))
            }
        }
    }

    func getFactsByCategory(_ category: CategoryDataModel, completion: @escaping (_ facts: Results<FactDataModel>?) -> Void) -> Void {
        //1 get facts from BD
        if let factsByCategory = persistencyManager.readFactFromBD(category: category), factsByCategory.count > 0 {
            completion(factsByCategory)
        }
        
        let lastOpenCategory = category.last_show
        print("-----Дата последнего открытия категории \(category.name) = \(lastOpenCategory)")
        let realm = try! Realm()
        try! realm.write {
            category.last_show = Date()
            print("-----Дата текущего открытия категории \(category.name) = \(category.last_show)")
        }
        
        let afterSomeTime = Date(timeInterval: 86400, since: lastOpenCategory)
        print("-----Дата спустя 1 день с последнего открытия категории \(category.name) = \(afterSomeTime)")
        
        let currentData = Date()
        
        if currentData >= afterSomeTime {
            print("-----Грузим с сервера! \(currentData) >= \(afterSomeTime)")

            if isOnline {
                //2 request from Server all categories
                httpClient.getFactsFromServer(category) { (_ factsInThisCategory: [AnyObject]) -> Void in
                    self.persistencyManager.writeFactsToBD(selectCategory: category, facts: factsInThisCategory, completion(self.persistencyManager.readFactFromBD(category: category)!)) }
            }
        }else{
            print("-----1 день не прошел с последнего открытия, с сервера не грузим!")
        }
    }
}
