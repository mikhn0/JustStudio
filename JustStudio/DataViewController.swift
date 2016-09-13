//
//  DataViewController.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import GoogleMobileAds
import UIKit
import SDWebImage

class DataViewController: UIViewController {

    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var dataObject: FactData!
    var activityIndicator: UIActivityIndicatorView?
    
    //override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated)
        
    override func viewDidLoad() {
        let url = NSURL(string: dataObject.image_url!)
        self.imageView.sd_setImageWithURL(url, placeholderImage:UIImage.init(named: "tree_bsckground"), options:SDWebImageOptions.CacheMemoryOnly , progress: { (receivedSize, expectedSize) in
                self.activityIndicator!.startAnimating()
            }) { (image, error, imageCacheType, url) in
                self.activityIndicator!.stopAnimating()
        }
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        var frame = self.dataLabel.frame
        frame.origin.x = 0
        frame.origin.y = 0
        blurredEffectView.frame = frame
        
        self.infoView.insertSubview(blurredEffectView, belowSubview: self.dataLabel)
        
        self.dataLabel!.text = dataObject.ru
        self.dataLabel!.shadowColor = UIColor.grayColor()
        self.dataLabel!.layer.shadowRadius = 4
        
        let color:UIColor! = UIColor.blackColor()
        self.dataLabel.layer.shadowColor = color.CGColor
        self.dataLabel.layer.shadowRadius = 4.0
        self.dataLabel.layer.shadowOpacity = 0.9
        self.dataLabel.layer.shadowOffset = CGSizeZero
        self.dataLabel.layer.masksToBounds = false
    }

        
    //}
}

