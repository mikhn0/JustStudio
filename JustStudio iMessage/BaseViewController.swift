//
//  BaseViewController.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 27.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages

struct Facts {
    var desc:String
    var image:String
    
    init(desc: String, image:String) {
        self.desc = desc
        self.image = image
    }
    
    init?(queryItems: [URLQueryItem]) {
        var desc: String! = ""
        var image: String! = String()
        
        for queryItem in queryItems {
            let name = queryItem.name
            let value = queryItem.value
            if name == "desc" {
                desc = value!
            } else if name == "image" {
                image = value!
            }
        }
        self.desc = desc
        self.image = image
    }
}



extension Facts {
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        items.append(URLQueryItem(name: "desc", value: self.desc))
        items.append(URLQueryItem(name: "image", value: self.image))
        
        return items
    }
}



extension Facts {
    
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else {return nil}
        
        self.init(queryItems: queryItems)
    }
    
}




class BaseViewController: UIViewController, UIViewControllerPreviewingDelegate {
    //FactCell
    func addGestureForEachCell(_ cell:UIView) {
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available
        {
            registerForPreviewing(with: self, sourceView: cell)
            //previewingContext(cell as! UIViewControllerPreviewing, commit: self)
        } else {
            
            // нет описания longPress
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
            longPress.minimumPressDuration = 0.5
            cell.addGestureRecognizer(longPress)
            
        }
    }
    
    
    // нужен класс PeekViewController.swift
    
    func longPressHandler(longPressView :UILongPressGestureRecognizer) {
        
        let previewSize = min(view.frame.width, view.frame.height) * 0.9
        let peekController = PeekViewController(frame: CGRect(x: 0, y: 0,
                                                              width: previewSize,
                                                              height: previewSize))
        peekController.asset = Facts(desc: "selectDesc", image: "selectImage")
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
    
    @available(iOS 9.0, *)
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let previewSize = min(view.frame.width, view.frame.height) * 0.9
        let peekController = PeekViewController(frame: CGRect(x: 0, y: 0,
                                                              width: previewSize,
                                                              height: previewSize))
        let selectDescription = (previewingContext.sourceView as? FactCell)?.descrLabel.text
        let selectImage = (previewingContext.sourceView as? FactCell)?.image_url
        peekController.asset = Facts(desc: selectDescription!, image: selectImage!)
        return peekController
    }

}
