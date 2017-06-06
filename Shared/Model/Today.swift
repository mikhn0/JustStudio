//
//  File.swift
//  JustStudio
//
//  Created by Maria on 18.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation

protocol TodayProtocol:BaseDataProtocol {
    var date: String {get}
    var year: Int {get}
}

class Today: TodayProtocol {
    
    var _id: String = ""
    var date: String = ""
    var year: Int = 0
    var en: String = ""
    var ru: String = ""
    var image_view: NSData?
    
    init(date:String, year:Int, en:String) {
        self.date = date
        self.year = year
        self.en = en
    }
}
