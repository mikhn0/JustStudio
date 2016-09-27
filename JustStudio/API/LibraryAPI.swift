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
    
    func getAllCategory(completion: @escaping ([CategoryData]) -> Void) {
        Alamofire.request("\(SERVER_URL)/categories")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    let jsonDict = JSON as! NSDictionary
                    let jsonCategoryArr = jsonDict["categories"] as! NSArray
                    
                    var categoryArr: [CategoryData] = []
                    for element in jsonCategoryArr {
                        let dict = element as! NSDictionary
                        let categoryData = CategoryData(id:(dict["_id"] as? String) , active:(dict["active"] as? Bool), en:(dict["en"] as? String), image_url:(dict["image"] as? String), name:(dict["name"] as? String), ru:(dict["ru"] as? String))
                        categoryArr.append(categoryData)
                        
                    }
                    //print("CATEGORIES ==== \(categoryArr)")
                    completion(categoryArr)

                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion([])

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
    

}
