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

protocol FactDataProtocol: BaseDataProtocol {
    var image: String! { get set }
    var image_view: NSData? { get set }
}

class FactDataModel: BaseDataModel, FactDataProtocol {
    dynamic var image: String!
    dynamic var category : String!
    dynamic var selectCategory: CategoryDataModel?
    dynamic var isLike : Bool = false
}
