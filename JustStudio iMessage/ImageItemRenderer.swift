//
//  ImageItemRenderer.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 28.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Messages

class ImageItemRenderer: UICollectionViewCell, PHPhotoLibraryChangeObserver
{
    let imageView = UIImageView()
    let labelDescription = UILabel()
    let blurOverlay = UIVisualEffectView(effect: UIBlurEffect())
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white
        
        labelDescription.numberOfLines = 0
        labelDescription.adjustsFontSizeToFitWidth = true
        labelDescription.textAlignment = NSTextAlignment.center
        
        contentView.addSubview(blurOverlay)
        contentView.addSubview(labelDescription)
        contentView.addSubview(imageView)
        
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5.5
        
    }
    
    override func layoutSubviews()
    {
        let labelFrame = CGRect(x: 0, y: frame.height - 30, width: frame.width, height: 30)
        
        blurOverlay.frame = labelFrame
        
        var imageFrame = labelFrame
        imageFrame.origin.y = 0
        imageFrame.size.height = frame.height - 30
        imageView.frame = imageFrame
        
        labelDescription.frame = labelFrame
    }
    
    var asset: Facts?
        {
        didSet
        {
            if asset != nil
            {
                DispatchQueue.global().async
                    {
                        self.setLabelDescription()
                        self.setImageView()
                }
            }
        }
    }
    
    func setImageView()
    {
        if let asset = asset
        {
            let image_url = asset.image
            
            URLSession.shared.dataTask(with: URL(string: image_url)!, completionHandler: { data, response, error in
                if (data != nil && error == nil) {
                    let image = UIImage(data: data!, scale: 1.0)
                    DispatchQueue.main.async
                        {
                            self.imageView.image = image
                    }
            }}).resume()
        }
    }
    
    func setLabelDescription()
    {
        if let asset = asset
        {
            let text = asset.desc
            
            DispatchQueue.main.async
                {
                    self.labelDescription.text = text
            }
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange)
    {
        DispatchQueue.main.async
            {
                
                self.setLabelDescription()
                self.setImageView()
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
