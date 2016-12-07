//
//  CategoryCell.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 01.11.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages


@available(iOS 10.0, *)
class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier: String? = "CategoryCell"
    
 //   @IBOutlet weak var activityView: UIView?
    @IBOutlet weak var categoryLabel: UILabel?
    @IBOutlet weak var categoryImage: UIImageView?
    
    override func awakeFromNib() {
        categoryLabel?.textColor = UIColor.init(red:71/255, green:90/255, blue:109/255, alpha:1)
        //titleLabel.font = UIFont.lightFont(ofSize: 20)
        categoryLabel?.minimumScaleFactor = 0.5
        
        //descrLabel.font = UIFont.altFont(ofSize: 20)
        categoryLabel?.minimumScaleFactor = 0.5
    }
    
    func getScreenShortOfCell() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates:false)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
    }
}
