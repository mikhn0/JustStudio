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
import RealmSwift
import Realm

protocol FactsVCDelegate: class {
    func chooseFactForSend (_ screenShot:UIImage, with fact: Facts)
}


class FactsVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var items: [Facts]! = []
    var facts: Results<FactDataModel>? {
        didSet {
            self.items = []
            let firstFact = facts?.first
            print("first fact = \(String(describing: firstFact?.category))")
            for elem in facts! {
                let fact:Facts
                fact = Facts(desc: UILabel.returnDescription(dataObject: elem), image: elem.image!)
                self.items.append(fact)
            }
        }
    }
    
    static let storyboardIdentifier = "FactsVC"
    var searchActive: Bool = false
    var lastSearchText:String = ""
    var filtered:[Facts] = []
    weak var delegate:FactsVCDelegate?
    var tap: UITapGestureRecognizer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFacts()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (searchActive == true && lastSearchText != "" ? filtered.count : items.count)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:(view.frame.size.width - 10.0) / 2, height:(view.frame.size.width - 10.0) * 233/181 / 2 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = (searchActive == true && lastSearchText != "" ? filtered[indexPath.row] : items[indexPath.row])
        return dequeueFactCell(for: item, at:indexPath)
    }
    
    private func dequeueFactCell(for fact:Facts, at indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: FactCell.reuseIdentifier!, for: indexPath) as! FactCell
        
        let url = URL(string: fact.image)
        let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
        
        let betweenString = urlWithService + fact.image
        let urlService = URL(string: betweenString)
        
        
        let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
            if error == nil {
                cell.image?.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
            }
        })
        task.resume()

        cell.descrLabel.text = fact.desc
        cell.image_url = fact.image
        
        addGestureForEachCell(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        let cell:FactCell! = collectionView.cellForItem(at: indexPath) as! FactCell
        
        delegate?.chooseFactForSend(cell.getScreenShortOfCell(), with: item)
        
    }
    
    func loadFacts() {
        // нет CoreData
       // let objects = (CoreDataManager.instance().allHacks() as? [NSManagedObject])!
       /* let objects //заглушка
        for elem in objects {
            let lifeHackNewObject:lifeHack?
            lifeHackNewObject =  lifeHack(title:elem.value(forKey: "title") as! String, subtitle:elem.value(forKey: "content") as! String)
            self.items.append(lifeHackNewObject!)
        }*/
        if facts != nil {
            for elem in facts! {
                let fact:Facts
                fact = Facts(desc: UILabel.returnDescription(dataObject: elem), image: elem.image!)
                self.items.append(fact)
            }
        }
    }
    
    func dismissKeyboard() {
        self.searchBar.endEditing(true)
        self.view.removeGestureRecognizer(tap!)
    }
    
}

extension FactsVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        
        tap = UITapGestureRecognizer(target: self, action: #selector(FactsVC.dismissKeyboard))
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
