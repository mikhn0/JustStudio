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
    
    init(id: String!, active:Bool!, en:String!, image_url:String!, name:String!, ru:String!)//, image:String!
    {
        super.init(id:id, ru:ru, en:en, active:active, image_url:image_url)
        self.name = name
 //      self.image = image
        
    }
}
