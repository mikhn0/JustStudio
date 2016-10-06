//
//  InterfaceController.swift
//  JustFacts WatchOS Extension
//
//  Created by Виктория on 16.09.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var categoryTable: WKInterfaceTable!
    var categories = InterfaceController.allCategories()
    var  selectedIndex = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        categoryTable.setNumberOfRows(categories.count, withRowType: "FlightRow")
        for index in 0..<categoryTable.numberOfRows {
            if let controller = categoryTable.rowController(at: index) as? CategoryRowController {
                controller.category = categories[index]
            }
        }
    }
    
    override func didAppear() {
        super.didAppear()
        if let controller = categoryTable.rowController(at: selectedIndex) as? CategoryRowController {
            animate(withDuration: 0.35, animations: { () -> Void in
                controller.updateForCheckIn()
            })
        }
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        selectedIndex = rowIndex
    }

    class func allCategories() -> [Category] {
        var categoriesArr = [Category]()
        
        let appGroupID = "group.fruktorum.JustFacts"
        
        let defaults = UserDefaults(suiteName: appGroupID)
        let ggg = defaults!.string(forKey: "CategoriesJson")
        print("ggg ===== \(ggg)")
        if let unit = defaults?.dictionary(forKey: "CategoriesJson") {
            let categories:[[String: AnyObject]] = unit["categories"] as! [[String: AnyObject]]
            for dict in categories {
                let category = Category(category: dict)
                categoriesArr.append(category)
            }
        }
        
        return categoriesArr
    }
}

