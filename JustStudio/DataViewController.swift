//
//  DataViewController.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import GoogleMobileAds
import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var dataObject: FactData!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("CURRENT FACT ==== \(dataObject)")
        
        let url = NSURL(string: dataObject.image_url!)
        self.imageView.sd_setImageWithURL(url)

        let blurEffect = UIBlurEffect(style: .Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        var frame = self.dataLabel.frame
        frame.origin.x = 0
        frame.origin.y = 0
        blurredEffectView.frame = frame
        
        self.infoView.insertSubview(blurredEffectView, belowSubview: self.dataLabel)
        
        self.dataLabel!.text = dataObject.facts
        self.dataLabel!.shadowColor = UIColor.lightGrayColor()
        
    }
}

