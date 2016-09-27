//
//  LibraryAPI.swift
//  JustStudio
//
//  Created by Imac on 18.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation
import Alamofire

let SERVER_URL:NSString = "http://justfacts.ju5tudio.com:5793"

class LibraryAPI : NSObject {
    
    static var instance: LibraryAPI!
    var pageData: [FactData] = []
    
    class func sharedInstance() -> LibraryAPI {
        self.instance = (self.instance ?? LibraryAPI())
        return self.instance
    }
    
    func getAllCategory(_ completion: @escaping (_ categories: [CategoryData]) -> Void) -> Void {
        Alamofire.request("\(SERVER_URL)/categories")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if response.result.value != nil {
                switch response.result {
                case .success(let JSON):
                    
                    DispatchQueue.global().async(execute: {//global(DispatchQueue.GlobalQueuePriority.high ,0).asynchronously(execute: {
                        
                    
                    //DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: JSON, options: JSONSerialization.WritingOptions.prettyPrinted)
                            
                            self.writeIntoFile(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String)
                            
                        } catch let error as NSError {
                            print(error)
                        }
                    })
                    //}
                    
                    let jsonDict = JSON as! NSDictionary
                    let jsonCategoryArr = jsonDict["categories"] as! [AnyObject]
                    
                    var categoryArr: [CategoryData] = []
                    let categories = jsonCategoryArr.shuffle()
                    for element in categories {
                        let dict = element as! NSDictionary
                        let categoryData = CategoryData(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), en:(dict["en"] as? String), image_url:(dict["image"] as? String), name:(dict["name"] as? String), ru:(dict["ru"] as? String))
                        categoryArr.append(categoryData)
                        
                    }
                    completion(categoryArr)
                    
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion([])
                    
                }
            }
        }
    }
    
    
    func getFactsByCategory(_ category:String, completion: @escaping (_ facts: [FactData]) -> Void) -> Void {
        Alamofire.request("\(SERVER_URL)/facts", parameters:["category":category])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                let jsonDict = response.result.value as! NSDictionary
                let jsonFactsArr = jsonDict["facts"] as! NSArray
                
                var factsArr: [FactData] = []
                for element in jsonFactsArr {
                    let dict = element as! NSDictionary
                    let categoryData = FactData(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), category:(dict["category"] as? String), en:(dict["en"] as? String), ru:(dict["ru"] as? String), image_url:(dict["image"] as? String))
                    factsArr.append(categoryData)
                    
                }
                //print("CATEGORIES ==== \(categoryArr)")
                completion(factsArr)
        }
    }
    
    
    func writeIntoFile (_ text:String) {
        let file = "Category.json" //this is the file. we will write to and read from it
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
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
        //var r = 0...count - 1
        for i in 0..<max {
            let j = Int(arc4random_uniform(UInt32(count.hashValue - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
    
}
