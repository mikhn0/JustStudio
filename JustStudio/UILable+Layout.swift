//
//  UILable+Layout.swift
//  JustStudio
//
//  Created by Виктория on 14.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class EdgeInsetLabel : UILabel {
    
    var edgeInsets = UIEdgeInsetsZero {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets), limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= edgeInsets.left
        rect.origin.y -= edgeInsets.top
        rect.size.width  += (edgeInsets.left + edgeInsets.right);
        rect.size.height += (edgeInsets.top + edgeInsets.bottom);
        
        return rect
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}