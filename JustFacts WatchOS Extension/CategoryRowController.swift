//
//  CategoryRowController.swift
//  JustStudio
//
//  Created by Виктория on 21.09.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import WatchKit

class CategoryRowController: NSObject {
    
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var image: WKInterfaceImage!
    
    // 1
    var category: Category? {
        // 2
        didSet {
            // 3
            if let category = category {
                // 4
                titleLabel.setText(category.en)
                image.setImageWithUrl(category.image_mini)
            }
        }
    }
    
    func updateForCheckIn () {
        let color = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        separator.setColor(color)
    }
    
}

public extension WKInterfaceImage {
    
    public func setImageWithUrl(_ url:String, scale: CGFloat = 1.0) {
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            if (data != nil && error == nil) {
                let image = UIImage(data: data!, scale: scale)
                
                DispatchQueue.main.async {
                    self.setImage(image)
                }
            }
            }) .resume()
    }
    
    func downloadedFrom(url: URL) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() { () -> Void in
                self.setImage(image)
            }
        }.resume()
    }
    
    func downloadedFrom(link: String) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
    
}

