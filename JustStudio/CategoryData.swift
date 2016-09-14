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
    var active : Bool!
    var en : String!
    var image_url : String!
    var name: String!
    var ru: String!
    var image: UIImage! = UIImage(named:"placeholder")
    
    init(id: String!, active:Bool!, en:String!, image_url:String!, name:String!, ru:String!) {
        super.init()
        self.id = id
        self.active = active
        self.en = en
        self.image_url = image_url
        self.name = name
        self.ru = ru
    }
}