//
//  HTTPClient.swift
//  JustStudio
//
//  Created by Виктория on 06.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import YandexMobileMetrica

class HTTPClient: NSObject {
    let persistencyManager = PersistencyManager()
    
    
    lazy var categoryArray: Results<CategoryDataModel> = {
        DispatchQueue.main.sync {
            let realm = try! Realm()
            return realm.objects(CategoryDataModel.self)
        }
    }()
    
    func getCategoriesFromServer(_ completion: @escaping (_ categories: [AnyObject]) -> Void) -> Void {
        let url = NSURL(string: "\(SERVER_URL)/categories")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                catchError(withText: error!)
                return
            }
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    DispatchQueue.main.sync {
                        let jsonCategoryArr = json["categories"] as! [AnyObject]
                        let categories = jsonCategoryArr.shuffle()
                    
                        completion(categories)
                    }
                }
            } catch let error as NSError {
                catchError(withText: error)
            }
        }
        task.resume()
    }
    
    func getFactsFromServer(_ category: CategoryDataModel, _ completion: @escaping (_ facts: [AnyObject]) -> Void) -> Void {
        let url = NSURL(string: "\(SERVER_URL)/facts?category=\(category.name)")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                catchError(withText: error!)
            }
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    
                    if let jsonFactsArr = json["facts"] as? [AnyObject] {
                        let facts = jsonFactsArr //запись перемешанных фактов в переменную facts
                        DispatchQueue.main.sync {
                            completion(facts)
                        }
                    } else {
                        completion([])
                    }
                }
            } catch let error as NSError {
                catchError(withText: error)
            }
        }
        task.resume()
    }
    
    func getRandomFactsFromServer(_ completion: @escaping (_ facts: [AnyObject]) -> Void) -> Void {
        let url = NSURL(string: "http://13.91.106.16:5793/facts")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                catchError(withText: error!)
            }
            
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    let jsonFactsArr = json["facts"] as! [AnyObject]
                    
                    var factsArr: [FactDataModel] = []
                    let facts = jsonFactsArr.shuffle()
                    for element in facts {
                        let dict = element as! NSDictionary
                        let factData = FactDataModel(value: dict)
                        factsArr.append(factData)
                    }
                    completion(factsArr)
                }
            } catch let error as NSError {
                catchError(withText: error)
            }
        }
        task.resume()
        
    }
    
    func getTodayFactsFromServer(_ completion: @escaping (_ todayFacts: [AnyObject]) -> Void) -> Void {
        let url = NSURL(string: "http://history.muffinlabs.com/date")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                catchError(withText: error!)
            }
            
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    let jsonTodayDate = json["date"] as! String
                    
                    let jsonTodayData = json["data"] as? [String:AnyObject]
                    let jsonTodayEvents = jsonTodayData?["Events"] as? [AnyObject]
                    
                    var todayFactsArr = [Today]()
                    let todayFacts = jsonTodayEvents?.shuffle()
                    
                    if todayFacts != nil {
                        for element in todayFacts! {
                            
                            let dictFact = element as! NSDictionary
                            let year = dictFact["year"] as! NSString
                            let textFact = dictFact["text"] as! String
                            let todayFactData = Today(date: jsonTodayDate, year: Int(year as String)!, en: textFact)
                            todayFactsArr.append(todayFactData)
                        }
                        completion(todayFactsArr)
                    }
                    DispatchQueue.main.sync {
                        completion(todayFactsArr)
                    }
                }
            } catch let error as NSError {
                catchError(withText: error)
            }
        }
        task.resume()
    }
    
    
}

extension Results {
    public func toShuffledArray<T>(ofType: T.Type) -> [T] {
        
        var array = [T]()
        
        for result in self {
            if let result = result as? T {
                array.append(result)
            }
        }
        
        let count = array.count
        
        if count > 1 {
            for i in 0..<(count - 1) {
                let j = Int(arc4random_uniform(UInt32(count - i))) + Int(i)
                swap(&array[i], &array[j])
            }
        }
        
        return array
    }
}

extension Collection {

    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        let max:Int = Int(count.hashValue-1)
        
        for i in 0..<max {
            let j = Int(arc4random_uniform(UInt32(count.hashValue - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
