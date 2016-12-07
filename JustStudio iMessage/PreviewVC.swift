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
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var LabelDescription: UITextView!
    
//    @IBOutlet weak var PreviewImage : UIImageView?
//    @IBOutlet weak var PreviewLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissSelf), name: NSNotification.Name(rawValue: "OpenScreenWithCompactStyle"), object: nil)
        
        labelTitle.text = item.image
        LabelDescription.text = item.desc
        

        
    }
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
