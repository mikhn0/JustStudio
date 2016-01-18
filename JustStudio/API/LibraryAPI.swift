//
//  LibraryAPI.swift
//  JustStudio
//
//  Created by Imac on 18.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation
import Alamofire

let SERVER_URL:NSString = "http://justfacts.ju5tudio.com:3000"

class LibraryAPI : NSObject {
    
    static var instance: LibraryAPI!
    var pageData: [FactData] = []
    
    class func sharedInstance() -> LibraryAPI {
        self.instance = (self.instance ?? LibraryAPI())
        return self.instance
    }
    
    func getAllCategory(completion: (categories: [CategoryData]) -> Void) -> Void {
        Alamofire.request(.GET, "\(SERVER_URL)/getcategories").responseJSON { response in
            let jsonDict = response.result.value as! NSDictionary
            let jsonCategoryArr = jsonDict["categories"] as! NSArray
            
            var categoryArr: [CategoryData] = []
            for element in jsonCategoryArr {
                let dict = element as! NSDictionary
                
                let arr = element["category"] as! NSArray
                let pre = NSLocale.preferredLanguages()[0]
                
                for var i=0; i<arr.count; i++ {
                    
                    let categoryDict = arr[i] as! NSDictionary
                    if pre.rangeOfString(categoryDict["language"] as! String) != nil {
                        
                        let categoryData = CategoryData(id:(dict["_id"] as! String), category:(categoryDict["categoryName"] as! String), language:(categoryDict["language"] as! String), image_url:(dict["image"] as! String))
                        categoryArr.append(categoryData)
                    }
                }

            }
            print("CATEGORIES ==== \(categoryArr)")
            completion(categories: categoryArr)
        }
    }
    
    func getAllFacts(completion: (facts: [FactData]) -> Void) -> Void {
        Alamofire.request(.GET, "\(SERVER_URL)/getfacts").responseJSON { response in
            if response.result.value != nil {
                let jsonDict = response.result.value as! NSDictionary
                let responseData = jsonDict["facts"] as! NSArray
                
                var responseArr: [FactData] = []
                for element in responseData {
                    
                    let dict = element as! NSDictionary
                    
                    let arr = element["fact"] as! NSArray
                    let pre = NSLocale.preferredLanguages()[0]
                    
                    for var i=0; i<arr.count; i++ {
                        
                        let factDict = arr[i] as! NSDictionary
                        if pre.rangeOfString(factDict["language"] as! String) != nil {
                            
                            let factData = FactData(id:(dict["_id"] as! String), facts:(factDict["fact"] as! String), language:(factDict["language"] as! String), image_url:(dict["image"] as! String))
                            responseArr.append(factData)
                            
                        }
                    }
                    
                }
                
                completion(facts: responseArr);
            } else {
                print("ERROR ==== \(response.result.error)")
            }

        }
    }
    
    
    func getFactsByCategory(categoryId:String, completion: (facts: [FactData]) -> Void) -> Void {
        Alamofire.request(.GET, "\(SERVER_URL)/getfacts", parameters: ["categoryId":categoryId]).responseJSON {
            response in
            let jsonDict = response.result.value as! NSDictionary
            let responseData = jsonDict["facts"] as! NSArray
            
            var responseArr: [FactData] = []
            for element in responseData {
            
                let dict = element as! NSDictionary
                
                let arr = element["fact"] as! NSArray
                let pre = NSLocale.preferredLanguages()[0]
                
                for var i=0; i<arr.count; i++ {
            
                    let factDict = arr[i] as! NSDictionary
                    if pre.rangeOfString(factDict["language"] as! String) != nil {
                    
                    let factData = FactData(id:(dict["_id"] as! String), facts:(factDict["fact"] as! String), language:(factDict["language"] as! String), image_url:(dict["image"] as! String))
                    responseArr.append(factData)
                    
                    }
                }
            
            }
                
            print("FILTERED FACTS ==== \(responseArr)")
            completion(facts: responseArr);
        }
    }
    

}
