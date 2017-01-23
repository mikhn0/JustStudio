//
//  JustStudioStickerCell.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 26.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages


@available(iOS 10.0, *)

class FactCell: UICollectionViewCell {
    static let reuseIdentifier: String? = "FactCell"
    @IBOutlet weak var image: UIImageView?
    @IBOutlet weak var descrLabel: UILabel!
    
    var image_url:String = ""
    
    override func awakeFromNib() {
        self.descrLabel?.textColor = UIColor.white
        self.descrLabel?.shadowColor = UIColor.gray
        self.descrLabel?.shadowOffset = CGSize(width: 1, height: -1)
        self.descrLabel?.font = UIFont(name: "AvusW00-CondensedMedium", size: 35)
        
        
    }
    
    func getScreenShortOfCell() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates:false)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
    }
}
