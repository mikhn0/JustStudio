//
//  AddStickersVC.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 26.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages
import ImageIO

protocol AddStickersVCDelegate: class {
    func chooseStickerToAddToCollection (_ screenShot:UIImage, with fact: Facts)
}


class AddStickersVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var items: [Facts]! = []
    
    static let storyboardIdentifier = "AddStickersVC"
    var searchActive: Bool = false
    var lastSearchText:String = ""
    var filtered:[Facts] = []
    weak var delegate:AddStickersVCDelegate?
    var tap: UITapGestureRecognizer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        loadStickers()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (searchActive == true && lastSearchText != "" ? filtered.count : items.count)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:(view.frame.size.width - 30.0) / 2, height:(view.frame.size.width - 30.0) / 2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = (searchActive == true && lastSearchText != "" ? filtered[indexPath.row] : items[indexPath.row])
        return dequeueStickerCell(for: item, at:indexPath)
    }
    
    private func dequeueStickerCell(for fact:Facts, at indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier!, for: indexPath) as! CategoryCell
        
//        cell.titleLabel.setTextWithCustomAttribute(text: fact.title)//.attributedText = attrString
//        cell.descrLabel.text = fact.subtitle
        
        addGestureForEachCell(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        let cell:FactCell! = collectionView.cellForItem(at: indexPath) as! FactCell
        
        delegate?.chooseStickerToAddToCollection(cell.getScreenShortOfCell(), with: item)
        
    }
    
    func loadStickers() {
        // нет CoreData
       // let objects = (CoreDataManager.instance().allHacks() as? [NSManagedObject])!
       /* let objects //заглушка
        for elem in objects {
            let lifeHackNewObject:lifeHack?
            lifeHackNewObject =  lifeHack(title:elem.value(forKey: "title") as! String, subtitle:elem.value(forKey: "content") as! String)
            self.items.append(lifeHackNewObject!)
        }*/
    }
    
    func dismissKeyboard() {
        self.searchBar.endEditing(true)
        self.view.removeGestureRecognizer(tap!)
    }
    
}

extension AddStickersVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        
        tap = UITapGestureRecognizer(target: self, action: #selector(AddStickersVC.dismissKeyboard))
        view.addGestureRecognizer(tap!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lastSearchText = searchText
        if searchText != "" {
            filtered = items.filter() {$0.desc.range(of: searchText, options: NSString.CompareOptions.caseInsensitive) != nil }
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        } else {
            searchActive = false
        }
        self.collectionView?.reloadData()
    }
}
