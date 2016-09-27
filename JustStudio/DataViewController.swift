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
    
    override func viewDidLoad() {
        let url = URL(string: dataObject.image_url!)
        self.imageView.sd_setImage(with: url, placeholderImage:dataObject.image, options:SDWebImageOptions.cacheMemoryOnly , progress: { (receivedSize, expectedSize) in
                self.activityIndicator!.startAnimating()
            }) { (image, error, imageCacheType, url) in
                self.activityIndicator!.stopAnimating()
        }
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        var frame = self.dataLabel.frame
        frame.origin.x = 0
        frame.origin.y = 0
        blurredEffectView.frame = frame
        
        //self.infoView.insertSubview(blurredEffectView, belowSubview: self.dataLabel)
        
        self.dataLabel!.text = dataObject.ru
        self.dataLabel!.shadowColor = UIColor.gray
        self.dataLabel!.layer.shadowRadius = 4
        
        let color:UIColor! = UIColor.black
        self.dataLabel.layer.shadowColor = color.cgColor
        self.dataLabel.layer.shadowRadius = 4.0
        self.dataLabel.layer.shadowOpacity = 0.9
        self.dataLabel.layer.shadowOffset = CGSize.zero
        self.dataLabel.layer.masksToBounds = false
    }

}

