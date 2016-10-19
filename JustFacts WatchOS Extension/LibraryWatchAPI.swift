//
//  LibraryWatchAPI.swift
//  JustStudio
//
//  Created by Виктория on 10.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

let SERVER_URL:NSString = "http://justfacts.ju5tudio.com:5793"

class LibraryWatchAPI : NSObject  {

        static var instance: LibraryWatchAPI!
        var pageData: [FactData] = []
        
        class func sharedInstance() -> LibraryWatchAPI {
            self.instance = (self.instance ?? LibraryWatchAPI())
            return self.instance
        }
    
    
    func getAllCategoryForWatch(_ completion: @escaping (_ categories: [Category]) -> Void) -> Void {
        
        let url = NSURL(string: "\(SERVER_URL)/categories")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if (error != nil) {
                print("API error: \(error), \(error?.localizedDescription)")
            }
            
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    let jsonCategoryArr = json["categories"] as! [AnyObject]
                    
                    var categoryArr: [Category] = []
                    let categories = jsonCategoryArr.shuffle()
                    for element in categories {
                        let dict = element as! NSDictionary
                        let categoryData = Category(_id: (dict["_id"] as? String)!, active: (dict["active"] as? Bool)!, ru: (dict["ru"] as? String)!, image: (dict["name"] as? String)!, en: (dict["en"] as? String)!, name: (dict["name"] as? String)!)
                        
                        categoryArr.append(categoryData)
                        
                    }
                    completion(categoryArr)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
        //----------
    }
    
        
        
        
        
        
        /*Alamofire.request("\(SERVER_URL)/categories")
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
                        
                        let jsonDict = JSON as! NSDictionary
                        let jsonCategoryArr = jsonDict["categories"] as! [AnyObject]
                        
                        var categoryArr: [Category] = []
                        let categories = jsonCategoryArr.shuffle()
                        for element in categories {
                            let dict = element as! [String : AnyObject]
                            let categoryData = Category(category: dict)
                            categoryArr.append(categoryData)
                            
                        }
                        completion(categoryArr)
                        
                        
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        completion([])
                        
                    }
                }
            }*/
    }
    

    /////

    func getFactsByCategoryForWatch(_ category:String, completion:@escaping([Fact]) -> Void) -> Void {
       //-----
        let url = NSURL(string: "\(SERVER_URL)/facts?category=\(category)")//\(SERVER_URL)/facts", parameters:["category":category]
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            print(" response ====== s\(response)")
            
            if (error != nil) {
                print("API error: \(error), \(error?.localizedDescription)")
            }
            
            do {
                if let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject] as NSDictionary? {
                    let jsonFactsArr = json["facts"] as! NSArray
                    
                    var factsArr: [Fact] = []
                    for element in jsonFactsArr {
                        let dict = element as! NSDictionary
                        let factData = Fact(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), ru:(dict["ru"] as? String), image:(dict["image"] as? String), en:(dict["en"] as? String), category:(dict["category"] as? String))
                        factsArr.append(factData)
                    }
                    completion(factsArr )
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        
        task.resume()
}
        //-----
        
        
        
        
        
        /*Alamofire.request("\(SERVER_URL)/facts", parameters:["category":category])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                let jsonDict = response.result.value as! NSDictionary
                let jsonFactsArr = jsonDict["facts"] as! NSArray
                
                var MyfactsArr: [Fact] = []
                for element in jsonFactsArr {
                    let dict = element as! NSDictionary
                    let factObject = Fact(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), ru:(dict["ru"] as? String), image:(dict["image"] as? String), en:(dict["en"] as? String) ,category:(dict["category"] as? String))
                    MyfactsArr.append(factObject)
                }
                
                completion(MyfactsArr)
                
        }*/




/////

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
