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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.titleLabel = EdgeInsetLabel.init()
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.shadowColor = UIColor.gray
        self.titleLabel.numberOfLines = 0
        self.titleLabel.shadowOffset = CGSize(width: 1, height: -1)
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 35)
        
        self.photoView = UIImageView()
        self.photoView.contentMode = UIViewContentMode.scaleAspectFill
        
        self.contentView.addSubview(self.photoView)
        self.contentView.addSubview(self.titleLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let contentRect = self.contentView.bounds
        self.photoView.frame = CGRect(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height)
        self.titleLabel.frame = CGRect(x: 20, y: contentRect.size.height-100, width: contentRect.size.width-40, height: 100)
        
        
    }
}
