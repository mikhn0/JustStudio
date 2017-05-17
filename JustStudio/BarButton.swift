//
//  File.swift
//  JustStudio
//
//  Created by Виктория on 11.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation
import SDWebImage
import Realm
import RealmSwift

class BarButton : UIButton {
    
    var facts: [FactDataModel]!
    var categoryViewController = CategoryViewController()
    var categoryDatailViewController = CategoryDetailViewController()
    
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
        addTarget(self, action: #selector(actionPressToday), for: .touchUpInside)
    }
    
    func styleButtonRandom() {
        setImage(UIImage(named: "ic_random"), for: .normal)
        setTitle("Random", for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 35, left: -85, bottom: 5, right: 0)
        addTarget(self, action: #selector(actionPressRandom), for: .touchUpInside)
    }
    
    func addFavoritesFacts() -> [FactDataModel] {
        
        var favoritesFacts = [FactDataModel]()
        let favoriteFactData = FactDataModel()
        
        if favoritesFacts == [], let likes = UserDefaults.standard.object(forKey: "LIKE_KEY"), (likes as AnyObject).count > 0 {
            print("add favorites facts 1")
            favoritesFacts.append(favoriteFactData)
        } else {
            print("remove favorites facts!")
            favoritesFacts.removeAll()
        }
        if favoritesFacts != [], (UserDefaults.standard.object(forKey: "LIKE_KEY") as! [AnyObject]).count > 0 {
            print("add favorites facts 2")
            favoritesFacts.append(favoriteFactData)
        }
        return favoritesFacts
    }
    
    func actionPressFavorites(sender: UIButton) {
        let favoritesFacts = addFavoritesFacts()
        if favoritesFacts == [] {
            if CategoryViewController.Instance != nil {
                CategoryViewController.Instance?.showAlert(title: "Error", message: "There are no favorites facts!")
            }
        }
    }
    
    func actionPressToday(sender: UIButton) {


    }
    
    func actionPressRandom(sender: UIButton) {
        
        DispatchQueue.main.async {
            LibraryAPI.sharedInstance().getRandomFacts("random", { (facts: Results<FactDataModel>?) -> Void in
                if facts != nil {
                    
                    self.categoryDatailViewController.ConfigurationViewControllers(facts!)
                }
                CategoryViewController.Instance?.showAlert(title: "Error", message: "There are no random facts!")
            })
        }

           // self.performSegue(withIdentifier: "FactsByCategorySegue", sender: self)

//        if CategoryViewController.Instance != nil {
//            CategoryViewController.Instance?.showAlert(title: "Error", message: "There are no random facts!")
//        }
    }
    
    
}