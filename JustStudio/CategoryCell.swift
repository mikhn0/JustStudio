//
//  CategoryCell.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class CategoryCell: UITableViewCell {
    var photoView : UIImageView!
    var titleLabel : EdgeInsetLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.titleLabel = EdgeInsetLabel.init()
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.shadowColor = UIColor.lightGrayColor()
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
        
        self.photoView = UIImageView.init()
        self.photoView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.contentView.addSubview(self.photoView)
        self.contentView.addSubview(self.titleLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let contentRect = self.contentView.bounds
        self.photoView.frame = CGRectMake(0, 0, contentRect.size.width, contentRect.size.height)
        self.titleLabel.frame = CGRectMake(20, 170, contentRect.size.width-40, 50)
    }
}