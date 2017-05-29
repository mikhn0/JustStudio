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
class CategoryCell: UITableViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        self.categoryLabel.textColor = UIColor.white
        self.categoryLabel.shadowColor = UIColor.gray
        self.categoryLabel.numberOfLines = 0
        self.categoryLabel.shadowOffset = CGSize(width: 1, height: -1)
        self.categoryLabel.font = UIFont(name: "AvusW00-CondensedMedium", size: 35)
        
        self.categoryImage.contentMode = .scaleAspectFill
    }
    
    func getScreenShortOfCell() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates:false)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
        
    }
}
