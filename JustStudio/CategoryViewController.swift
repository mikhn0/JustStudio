//
//  CategoryViewController.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import SDWebImage
import RealmSwift
import WatchConnectivity

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BarButtonDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonFavorites: BarButton!
    @IBOutlet weak var buttonToday: BarButton!
    @IBOutlet weak var buttonRandom: BarButton!
    
    let textCellIdentifier = "CategoryCell"
    var categories: Results<CategoryDataModel>?
    var indexesOfDifferenceObject:[Int:CategoryDataModel] = [:]
    var currentUpdateCategoryData:CategoryDataModel?
    var countOfCategories:Int?
    var heightOfCell: CGFloat = 0.0
    
    static var Instance: CategoryViewController?
    
    let httpClient = HTTPClient()
    
    var realm : Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CategoryViewController.Instance = self
        
        buttonFavorites.styleButtonFavorites()
        buttonToday.styleButtonToday()
        buttonToday.delegate = self
        buttonRandom.styleButtonRandom()
        buttonRandom.delegate = self
        
        LibraryAPI.sharedInstance().getAllCategory ({ (categories: Results<CategoryDataModel>?) -> Void in
            if categories != nil {
                if self.categories != nil {
                    let categoriesRef = ThreadSafeReference(to: categories!)
                    let oldCategoriesRef = ThreadSafeReference(to: self.categories!)
                    
                    DispatchQueue(label: ".CheckDifCateg").async {
                        let realm = try! Realm()
                        guard let categ = realm.resolve(categoriesRef) else {
                            return
                        }
                        guard let oldCateg = realm.resolve(oldCategoriesRef) else {
                            return
                        }
                        self.checkDifferenceCategoriesInDB(categoriesFromDB: categ, oldCategories: oldCateg)
                    }
                } else {
                    self.categories = categories; //запись категорий
                    self.countOfCategories = categories?.count
                    self.tableView.reloadData()
                    
                }
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        heightOfCell = (self.view.frame.size.height + 20) / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func checkDifferenceCategoriesInDB(categoriesFromDB: Results<CategoryDataModel>, oldCategories: Results<CategoryDataModel>) {
        if countOfCategories == categoriesFromDB.count {
            for elem in categoriesFromDB {
                if oldCategories.contains(elem) == false {
                    if let index = oldCategories.index(of: elem) {
                        indexesOfDifferenceObject[index] = elem
                    }
                }
            }
            if indexesOfDifferenceObject.count > 0 {
                for (key, value) in indexesOfDifferenceObject {
                    let categoryRef = ThreadSafeReference(to: value)
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        let indexPath:IndexPath = IndexPath(row: key, section: 0)
                        let realm = try! Realm()
                        guard let categ = realm.resolve(categoryRef) else {
                            return
                        }
                        self.currentUpdateCategoryData = categ
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                        self.tableView.endUpdates()
                    }
                }
                self.categories = categoriesFromDB
            }
        }
    }
    
    // ----- UITableViewDelegate START -----
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCategory: CategoryDataModel = categories![(indexPath as NSIndexPath).row]
        
        switch selectCategory.name {
        case "quotes":
            openApp(bySchema: "readmyquotesapp://", withUrl: "https://itunes.apple.com/us/app/just-quotes-did-you-know/id1190672970")
        case "celebrity":
            openApp(bySchema: "readmypeopleapp://", withUrl: "https://itunes.apple.com/us/app/just-people-did-you-know/id1197390666")
        default:
            performSegue(withIdentifier: "FactsByCategorySegue", sender: selectCategory)
        }
    }
    
    // ----- UITableViewDelegate END -----
    // ----- UITableViewDataSource START -----
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfCategories ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = (indexPath as NSIndexPath).row
        let categoryData = currentUpdateCategoryData != nil ? currentUpdateCategoryData : categories?[row]
        let model = CategoryCellModel(photoUrl: (categoryData?.image)!, photoData: categoryData?.image_view, title: returnDescriptionForApp(categoryData!))
        
        currentUpdateCategoryData = nil
        return tableView.dequeueReusableCell(viewModel: model, for: indexPath)
        
    }
    // ----- UITableDataSource END -----
    // ----- BarButtonDataSource START -----
    
    func displayFacts(_ facts: [BaseDataProtocol]) {
        performSegue(withIdentifier: "FactsByCategorySegue", sender: facts)
    }
    
    // ----- BarButtonDataSource END -----
    // ----- Segue UIViewController START -----
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FactsByCategorySegue" {
            
            let categoryDetailViewController = segue.destination as! CategoryDetailViewController
            
            if let category = sender as? CategoryDataModel {
                categoryDetailViewController.category = category
                
            } else if let randomFacts = sender as? [FactDataProtocol] {
                categoryDetailViewController.randomFacts = randomFacts
                
            } else if let todayFacts = sender as? [TodayProtocol] {
                categoryDetailViewController.todayFacts = todayFacts
            }
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) -> Void {
        if segue.identifier == "unwindToViewController" { print("UNVIND SEGUE") }
    }
    
    // ----- Segue UIViewController END -----
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(OKAction)
        present(alertController, animated: true) { }
    }

}

protocol Sequence {
    var countResults: Int? {get}
    subscript (byIndex index:Int) -> BaseDataProtocol {get}
}

extension Results: Sequence {
    
    subscript(byIndex index: Int) -> BaseDataProtocol {
        return self[index] as! BaseDataProtocol
    }

    var countResults: Int? {
        return count
    }

}

extension Array: Sequence {
    
    subscript(byIndex index: Int) -> BaseDataProtocol {
        return self[index] as! BaseDataProtocol
    }
    
    var countResults: Int? {
        return count
    }
    
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : BaseDataModel {
        if self.filter({($0 as? T)?._id == obj._id}).count > 0 {
            return self.filter({$0 as? T == obj}).count > 0
        } else {
            return false
        }
    }
}
