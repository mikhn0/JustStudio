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
    @IBOutlet var backgroundGroup: WKInterfaceGroup!

    var fact: Fact? {
        didSet {
            if let fact = fact {
                factLabel.setText(fact.en)
                factImage.downloadedFrom(link: "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_300/"+fact.image)
            }
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let fact = context as? Fact { self.fact = fact }
    }
}
