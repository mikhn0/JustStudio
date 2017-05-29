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
            for elem in facts! {
                let fact:Facts
                fact = Facts(desc: returnDescriptionForApp(elem), image: elem.image ?? "", image_data: elem.image_view as Data?)
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
    var heightOfVC: CGFloat?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadFacts()
    }
    
    override func viewDidLayoutSubviews() {
        // view
        let x:CGFloat      = self.view.bounds.origin.x
        let y:CGFloat      = self.view.bounds.origin.y
        let width:CGFloat  = self.view.bounds.width
        let height:CGFloat = heightOfVC!
        let frame:CGRect   = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.frame           = frame
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
        let model = FactCellModel(photoUrl: fact.image, photoData: fact.image_data as NSData?, title: fact.desc)
        let cell = collectionView!.dequeueReusableCell(viewModel: model, for: indexPath)
        addGestureForEachCell(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! FactCell
        let screenShortCell = cell.getScreenShortOfCell()
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenScreenWithCompactsStyle"), object: nil)
        delegate?.chooseFactForSend(screenShortCell, with: item)
    }
    
    func loadFacts() {
        if facts != nil {
            for elem in facts! {
                let fact = Facts(desc: returnDescriptionForApp(elem), image: elem.image!, image_data: elem.image_view! as Data)
                items.append(fact)
            }
        }
    }
    
    func dismissKeyboard() {
        searchBar.endEditing(true)
        view.removeGestureRecognizer(tap!)
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
