//
//  File.swift
//  JustStudio
//
//  Created by Maria on 18.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation

class Today: NSObject {
    
    var date: String
    var year: Int
    var text: String
    
    init(_ date: String, _ year: Int, _ text: String) {
        self.date = date
        self.year = year
        self.text = text
    }
}
