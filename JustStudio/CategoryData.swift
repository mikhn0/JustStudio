//
//  CategoryData.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class CategoryData: NSObject {
    var id : String!
    var category : String!
    var language : String!
    var image_url : String!
    
    init(id: String, category:String, language:String, image_url:String) {
        super.init()
        self.id = id
        self.category = category
        self.language = language
        self.image_url = image_url
    }
}