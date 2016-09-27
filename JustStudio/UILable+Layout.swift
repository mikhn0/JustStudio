//
//  UILable+Layout.swift
//  JustStudio
//
//  Created by Виктория on 14.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class EdgeInsetLabel : UILabel {
    
    var edgeInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width  += (edgeInsets.left + edgeInsets.right);
        rect.size.height += (edgeInsets.top + edgeInsets.bottom);
        
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}
