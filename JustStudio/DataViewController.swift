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
        let betweenString = urlWithService + dataObject.image_url
        let urlService = URL(string: betweenString)
        
        self.activityIndicator!.startAnimating()
        if dataObject.image == nil {
            let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.imageView.sd_setImage(with: url, placeholderImage: UIImage(data:data!), options: SDWebImageOptions.cacheMemoryOnly, completed: { (image, error, imageCacheType, url) in
                            self.imageView.image = image
                            self.activityIndicator!.stopAnimating()
                        })
                    }
                }
            })
            task.resume()
        } else {
            self.imageView.image = dataObject.image
            self.activityIndicator!.stopAnimating()
        }
        
        self.dataLabel.setDescription(dataObject: dataObject)
        
        let color:UIColor! = UIColor.black
        self.dataLabel.layer.shadowColor = color.cgColor
        self.dataLabel.layer.shadowRadius = 4.0
        self.dataLabel.layer.shadowOpacity = 0.9
        self.dataLabel.layer.shadowOffset = CGSize.zero
        self.dataLabel.layer.masksToBounds = false
    }

}

