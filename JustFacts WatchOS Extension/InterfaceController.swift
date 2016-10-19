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
    var categories:[Category]?
    var  selectedIndex = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.allCategories()
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
        
        LibraryWatchAPI.sharedInstance().getFactsByCategoryForWatch ( (categories?[rowIndex].name)! , completion:{ (facts: [Fact]) -> Void in
 
            var contexts: [Fact] = []
            var controllers:  [String] = []
            
            for elem in facts {
                contexts.append(elem)
                controllers.append("FactsController")
                }
//            contexts.append(facts[0])
//            controllers.append("FactsController")
            self.presentController(withNames: controllers, contexts:  contexts);
        })
    }

    
    
    func allCategories() {
        //var categoriesArr = [Category]()
        
        LibraryWatchAPI.sharedInstance().getAllCategoryForWatch ({ (categories: [Category]) -> Void in
            
            print(" getAllCategory ====!= \(categories)")
            self.categories = categories
            
            self.prepareTable()
        })
        
    }
    
    
    

    
    
    func prepareTable () {
        categoryTable.setNumberOfRows((categories?.count)!, withRowType: "CategoryRow")
        for index in 0..<categoryTable.numberOfRows {
            if let controller = categoryTable.rowController(at: index) as? CategoryRowController {

                    controller.category = categories?[index]
               
        }
   }
}
}
