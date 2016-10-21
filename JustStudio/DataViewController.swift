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
        
        let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
        let betweenString = urlWithService+dataObject.image_url
        let urlService = URL(string: betweenString)
        
        
        self.activityIndicator!.startAnimating()
        let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
            if error == nil {
                self.imageView.sd_setImage(with: url, placeholderImage:UIImage(data:data!), options:SDWebImageOptions.cacheMemoryOnly , progress: nil, completed: { (image, error, imageCacheType, url) in
                    self.activityIndicator!.stopAnimating()
                })
    
            }
        })
        task.resume()
        
        
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        var frame = self.dataLabel.frame
//        frame.origin.x = 0
//        frame.origin.y = 0
//        blurredEffectView.frame = frame
        
        self.dataLabel.setDescription(dataObject: dataObject)
        
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

