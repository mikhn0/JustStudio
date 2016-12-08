//
//  LibraryAPI.swift
//  JustStudio
//
//  Created by Imac on 18.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation

let SERVER_URL:NSString = "http://13.91.106.16:5793/"

class LibraryAPI : NSObject  {
    
    static var instance: LibraryAPI!
    var pageData: [FactData] = []
    
    class func sharedInstance() -> LibraryAPI {
        self.instance = (self.instance ?? LibraryAPI())
        return self.instance
    }
    
    func getAllCategory(_ completion: @escaping (_ categories: [CategoryData]) -> Void) -> Void {
        
        let url = NSURL(string: "\(SERVER_URL)/categories")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                print("API error: \(error), \(error?.localizedDescription)")
            }
            
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    let jsonCategoryArr = json["categories"] as! [AnyObject]
                    
                    var categoryArr: [CategoryData] = []
                    let categories = jsonCategoryArr.shuffle()
                    for element in categories {
                        let dict = element as! NSDictionary
                        let categoryData = CategoryData(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), en:(dict["en"] as? String), image_url:(dict["image"] as? String), name:(dict["name"] as? String), ru:(dict["ru"] as? String))
                        categoryArr.append(categoryData)
                        
                    }
                    completion(categoryArr)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    
    task.resume()
        
    }

    func getFactsByCategory(_ category:String, completion: @escaping (_ facts: [FactData]) -> Void) -> Void {
        
        let url = NSURL(string: "\(SERVER_URL)/facts?category=\(category)")
        print("url = \(url)")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                print("API error: \(error), \(error?.localizedDescription)")
            }
            print("response = \(response)")
            do {
                
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    let jsonFactsArr = json["facts"] as! [AnyObject]
                    let facts = jsonFactsArr.shuffle()
                    var factsArr: [FactData] = []
                    for element in facts {
                        let dict = element as! NSDictionary
                        let factData = FactData(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), category:(dict["category"] as? String), en:(dict["en"] as? String), ru:(dict["ru"] as? String), image_url:(dict["image"] as? String))
                        factsArr.append(factData)
                    }
                    completion(factsArr)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
       
        
        task.resume()
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
