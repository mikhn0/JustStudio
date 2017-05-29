//
//  PreviewVC.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 26.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages
import ImageIO


class PreviewVC: BaseViewController {
    
    var item: Facts!
    
    static let storyboardIdentifier = "PreviewVC"
    
    @IBOutlet var previewImage : UIImageView!
    @IBOutlet var previewLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissSelf), name: NSNotification.Name(rawValue: "OpenScreenWithCompactStyle"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: item.image)
        let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
        
        let betweenString = urlWithService + item.image
        let urlService = URL(string: betweenString)
        
        
        let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
            if error == nil {
                self.previewImage.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
            }
        })
        task.resume()
        previewLabel.text = item.desc
    }
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
