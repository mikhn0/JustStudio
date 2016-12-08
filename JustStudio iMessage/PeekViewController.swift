//
//  PeekViewController.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 28.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Photos

class PeekViewController: UIViewController
{
    let itemRenderer: ImageItemRenderer
    required init(frame: CGRect)
    {
        itemRenderer = ImageItemRenderer(frame: frame)
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = frame.size
        view.addSubview(itemRenderer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var asset: Facts?
        {
        didSet
        {
            if let asset = asset
                {
                    itemRenderer.asset = asset;
                }
        }

    }

}


