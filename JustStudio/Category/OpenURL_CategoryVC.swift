//
//  OpenURL_CategoryVC.swift
//  JustStudio
//
//  Created by a1 on 23.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation

extension CategoryViewController {
    
    func openApp(bySchema schema:String, withUrl url:String) {
        let justQuotesUrl = URL(string: schema)
        if UIApplication.shared.canOpenURL(justQuotesUrl!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(justQuotesUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(justQuotesUrl!)
            }
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: url)!)
            }
        }

    }
}
