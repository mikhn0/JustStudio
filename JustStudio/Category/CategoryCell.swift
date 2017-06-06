//
//  CategoryCell.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class CategoryCell: UITableViewCell {
    @IBOutlet var photoView : UIImageView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    var titleLabel : EdgeInsetLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel = EdgeInsetLabel.init()
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.shadowColor = UIColor.gray
        self.titleLabel.numberOfLines = 0
        self.titleLabel.shadowOffset = CGSize(width: 1, height: -1)
        self.titleLabel.font = UIFont(name: "AvusW00-CondensedMedium", size: 35)
        
        self.contentView.addSubview(self.titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentRect = contentView.bounds
        self.titleLabel.frame = CGRect(x: 20, y: contentRect.size.height-100, width: contentRect.size.width-40, height: 100)
    }
}
