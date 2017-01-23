//
//  CategoryData.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import UIKit


class CategoryData: BaseData {
    var name: String!
    var image: UIImageView?
    
    init(_ id: String!, _ active:Bool!, _ en:String!, _ image_url:String!, _ name:String!, _ ru:String!) {
        super.init(id, ru, en, active, image_url)
        self.name = name
    }
    
    convenience init(category: [String: AnyObject]) {
        let id = category["_id"] as! String
        let active = category["active"] as! Bool
        let ru = category["ru"] as! String
        let image = category["image"] as! String
        let en = category["en"] as! String
        let name = category["name"] as! String
        
        self.init(id, active, en, image, name, ru)
    }
}
