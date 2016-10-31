//
//  FactData.swift
//  JustStudio
//
//  Created by Imac on 21.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import Foundation

class FactData: BaseData {
    
    var category : String!
    var image : UIImage?// = UIImage(named:"tree_background")
    
    init(id:String!, active:Bool!, category:String!, en:String!, ru:String!, image_url:String!) {
        super.init(id:id, ru:ru, en:en, active:active, image_url:image_url)
        self.category = category
    }
}
