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

protocol DataModelVCProtocol {
    associatedtype Item
    var dataObject: Item? {get set}
    var activityIndicator: UIActivityIndicatorView? {get set}
}

class DataViewController: UIViewController, DataModelVCProtocol {
    
    typealias Item = FactDataProtocol
    var dataObject: Item?
    var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        if (dataObject!.image_view != nil) {
            imageView.image = UIImage(data: dataObject!.image_view! as Data)
            activityIndicator!.stopAnimating()
        } else {
            if dataObject!.image != nil {
                let url = URL(string: dataObject!.image!)
                
                let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
                let betweenString = urlWithService + dataObject!.image!
                let urlService = URL(string: betweenString)
                
                activityIndicator!.startAnimating()
                
                let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(data:data!), options: SDWebImageOptions.cacheMemoryOnly, completed: { (image, error, imageCacheType, url) in
                                self.activityIndicator!.stopAnimating()
                            })
                        }
                    }
                })
                task.resume()
            } else {
                activityIndicator!.stopAnimating()
                
                let alertController = UIAlertController(title: "Error", message: "This fact has not image.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in}
                alertController.addAction(OKAction)
                
                present(alertController, animated: true) {}

            }
        }
        self.dataLabel.setDescription(dataObject: dataObject!)
        
        let color:UIColor! = UIColor.black
        dataLabel.layer.shadowColor = color.cgColor
        dataLabel.layer.shadowRadius = 4.0
        dataLabel.layer.shadowOpacity = 0.9
        dataLabel.layer.shadowOffset = CGSize.zero
        dataLabel.layer.masksToBounds = false
    }

}

