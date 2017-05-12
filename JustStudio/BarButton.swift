//
//  File.swift
//  JustStudio
//
//  Created by Виктория on 11.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation

class BarButton : UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        styleButton()
    }
    
    private func styleButton() {
        self.imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 10, left: 22, bottom: 20, right: 22)
        tintColor = UIColor.white
        titleLabel!.font = UIFont(name: "AvusW00-CondensedMedium", size: 12)
    }
    
    func styleButtonFavorites() {
        setImage(UIImage(named: "ic_liked"), for: .normal)
        setTitle("Favorites", for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 35, left: -30, bottom: 5, right: 0)
        addTarget(self, action: #selector(actionPressFavorites), for: .touchUpInside)
    }
    
    func styleButtonToday() {
        setImage(UIImage(named: "ic_history"), for: .normal)
        setTitle("Today", for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 35, left: -40, bottom: 5, right: 0)
    }
    
    func styleButtonRandom() {
        setImage(UIImage(named: "ic_random"), for: .normal)
        setTitle("Random", for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 35, left: -85, bottom: 5, right: 0)
    }
    
    func actionPressFavorites(sender:BarButton) {
        
    }
}
