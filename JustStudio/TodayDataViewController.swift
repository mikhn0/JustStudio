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

class TodayDataViewController: UIViewController, DataModelVCProtocol {
    
    typealias TypePage = TodayDataViewController
    typealias Item = TodayProtocol
    var dataObject: TodayProtocol?
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        
        imageView.image = UIImage(named: "TodayBackground")
        dataLabel.setDescription(dataObject: dataObject!)
        
        let color:UIColor! = UIColor.black
        dataLabel.layer.shadowColor = color.cgColor
        dataLabel.layer.shadowRadius = 4.0
        dataLabel.layer.shadowOpacity = 0.9
        dataLabel.layer.shadowOffset = CGSize.zero
        dataLabel.layer.masksToBounds = false
        
        todayDateLabel.text = dataObject!.date
        yearLabel.text = "\(dataObject!.year)"
        
        activityIndicator?.stopAnimating()
    }
    
}

