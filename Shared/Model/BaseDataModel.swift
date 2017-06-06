//
//  BaseDataModel.swift
//  JustStudio
//
//  Created by Виктория on 04.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import WatchKit

protocol BaseDataProtocol {
    var _id: String { get set }
    var ru: String { get set }
    var en: String { get set }
    var image_view: NSData? { get set }
}

class BaseDataModel: Object {
    
    dynamic var _id: String = ""
    dynamic var active: Bool = false
    dynamic var ru: String = ""
    dynamic var en: String = ""
    dynamic var image_view: NSData?
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}


