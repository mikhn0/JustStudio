//
//  FactsController.swift
//  JustStudio
//
//  Created by Виктория on 11.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import WatchKit
import Foundation

class FactsController: WKInterfaceController {

    @IBOutlet var factLabel: WKInterfaceLabel!
    @IBOutlet var factImage: WKInterfaceImage!


    
    // 1
    var fact: Fact? {
        // 2
        didSet {
            // 3
            if let fact = fact {
                // 4
                factLabel.setText(fact.en)
              
                self.factImage.setImageWithUrl(fact.image)
                
            }
        }
    }


    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let fact = context as? Fact { self.fact = fact }
    }
    
}
