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
 
    dynamic var image: String!
    dynamic var category : String!
    dynamic var selectCategory: CategoryDataModel?
    dynamic var isLike : Bool = false
    dynamic var random : String!
}
