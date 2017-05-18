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
import SystemConfiguration

let SERVER_URL:NSString = "http://13.91.106.16:5793/"

class LibraryAPI : NSObject  {
    
    let persistencyManager: PersistencyManager
    let httpClient: HTTPClient
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
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
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
        }) else { return false }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) { return false }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func getCategoriesFromDB_ForWatch(_ completion: (_ data:Data?) -> Void) {

        let resultReadCategoryFromDB = persistencyManager.readCategoryFromBD()
        
        if resultReadCategoryFromDB != nil, (resultReadCategoryFromDB?.count)! > 0 {
            var result = [Category]()
            for elem in resultReadCategoryFromDB! {
                let category_obj = Category(withRealm: elem)
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
    
    func getFactsFromDB_ForWatch(_ category: String, _ completion: (_ data:Data?) -> Void) {
        let resultReadFactsFromDB = persistencyManager.readFactFromDB_ForWatch(category: category)
        
        if resultReadFactsFromDB != nil, (resultReadFactsFromDB?.count)! > 0 {
            var result = [Fact]()
            for elem in resultReadFactsFromDB! {
                let fact_obj = Fact(withRealm: elem)
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
    
    func getAllCategory(_ completion: @escaping (_ categories:  Results<CategoryDataModel>? ) -> Void) {
        
        //1 get categories from BD
        if let categoriesFromDB = self.persistencyManager.readCategoryFromBD(), categoriesFromDB.count > 0 {
            completion(categoriesFromDB)
        }
        
        if LibraryAPI.isConnectedToNetwork() {
            //2 request from Server all categories
            httpClient.getCategoriesFromServer() { (_ categories: [AnyObject]) -> Void in
                self.persistencyManager.writeCategoriesToBD(categories: categories, completion(self.persistencyManager.readCategoryFromBD()!))
            }
        }
    }
    
    func getRandomFacts(_ completion: @escaping (_ facts: [AnyObject]?) -> Void) -> Void {
        
        if LibraryAPI.isConnectedToNetwork() {
            httpClient.getRandomFactsFromServer() { (_ facts: [AnyObject]) -> Void in
                completion(facts)
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

            if LibraryAPI.isConnectedToNetwork() {
                //2 request from Server all categories
                httpClient.getFactsFromServer(category) { (_ factsInThisCategory: [AnyObject]) -> Void in
                    self.persistencyManager.writeFactsToBD(selectCategory: category, facts: factsInThisCategory, completion(self.persistencyManager.readFactFromBD(category: category)!)) }
            }
        }else{
            print("-----1 день не прошел с последнего открытия, с сервера не грузим!")
        }
    }

    
}
