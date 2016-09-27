//
//  Flight.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit

class Category {
  
  let _id: String
  let active: Bool
  let isAdmin: Bool
  let ru: String
  let image: String
  let en: String
  let name: String
    
  
  class func allCategories() -> [Category] {
    var categoriesArr = [Category]()
    
    if let path = Bundle.main.path(forResource: "Category", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, AnyObject>
        let categories:[[String: AnyObject]] = json["categories"] as! [[String: AnyObject]]
        for dict in categories {
            let category = Category(category: dict)
            categoriesArr.append(category)
        }
      } catch {
        print(error)
      }
    }
    return categoriesArr
  }
  
  init(_id: String, active: Bool, isAdmin: Bool, ru: String, image: String, en: String, name: String) {
    self._id = _id
    self.active = active
    self.isAdmin = isAdmin
    self.ru = ru
    self.image = image
    self.en = en
    self.name = name
  }
  
  convenience init(category: [String: AnyObject]) {
    let id = category["_id"]!
    let active = category["active"]!
    let isAdmin = category["isAdmin"]!
    let ru = category["ru"]!
    let image = category["image"]!
    let en = category["en"]!
    let name = category["name"]!
    
    
    self.init(_id: id as! String, active: active as! Bool, isAdmin: isAdmin as! Bool, ru: ru as! String, image: image as! String, en: en as! String, name: name as! String)
  }
    
    func readFromFile () -> String {
        let file = "Category.json" //this is the file. we will write to and read from it
        var text: String = ""
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            //reading
            do {
                text = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print("text \(text)")
            }
            catch {
            }
        }
        return text
    }
}
