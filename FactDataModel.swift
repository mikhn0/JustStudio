//
//  FactDataModel.swift
//  JustStudio
//
//  Created by Виктория on 04.04.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import RealmSwift
import WatchKit

class FactDataModel: BaseDataModel {
 
    dynamic var image: String! = nil
    dynamic var category : String! = nil
    dynamic var selectCategory: CategoryDataModel?
    dynamic var isLike : Bool = false
}
