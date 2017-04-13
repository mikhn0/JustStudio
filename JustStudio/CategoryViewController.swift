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

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "CategoryCell"
    var categories: Results<CategoryDataModel>?
    var indexesOfDifferenceObject:[Int:CategoryDataModel] = [:]
    var currentUpdateCategoryData:CategoryDataModel?
    var countOfCategories:Int?
    var heightOfCell: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        LibraryAPI.sharedInstance().getAllCategory ({ (categories: Results<CategoryDataModel>?) -> Void in
            if categories != nil {
                if self.categories != nil {
                    let categoriesRef = ThreadSafeReference(to: categories!)
                    let oldCategoriesRef = ThreadSafeReference(to: self.categories!)
                    
                    DispatchQueue(label: ".CheckDifCateg").async {
                        let realm = try! Realm()
                        guard let categ = realm.resolve(categoriesRef) else {
                            return // person was deleted
                        }
                        guard let oldCateg = realm.resolve(oldCategoriesRef) else {
                            return // person was deleted
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
            
            /*else {
                let alertController = UIAlertController(title: "Error", message: "System error.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self?.present(alertController, animated: true) {
                    // ...
                }
            }*/

        //проверяем 1. существует ли база-таблицы-данные, если да, то записываем категории
        
        tableView.delegate = self
        tableView.dataSource = self
        heightOfCell = (self.view.frame.size.height + 20) / 2
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
                            return // person was deleted
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
    
    //#pragma - mark UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell
    }
    
    
    //#pragma - mark UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfCategories ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryCell(style: UITableViewCellStyle.value1, reuseIdentifier: textCellIdentifier)
        
        let row = (indexPath as NSIndexPath).row
        
        let categoryData = currentUpdateCategoryData != nil ? currentUpdateCategoryData : categories?[row]
  
        cell.titleLabel.setDescription(dataObject: categoryData!)

        cell.titleLabel.sizeToFit()
        
        if let categoryImage = categoryData?.image, categoryImage != "" {
            
            if categoryData!.image_view != nil {
                cell.photoView.image = UIImage(data:categoryData!.image_view! as Data)
            } else {
                
                let url = URL(string: categoryImage)
                let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
                
                let urlService = URL(string: urlWithService+categoryData!.image)
     
                let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                        if error == nil {
                            DispatchQueue.main.async {
                                cell.photoView.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
                            }
                        }
                })
                task.resume()
            }
        }
        currentUpdateCategoryData = nil
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCategory: CategoryDataModel = categories![(indexPath as NSIndexPath).row]
        
        switch selectCategory.name {
            case "quotes":
                let justQuotesSchema = "readmyquotesapp://"
                let justQuotesUrl = URL(string: justQuotesSchema)
                if UIApplication.shared.canOpenURL(justQuotesUrl!) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(justQuotesUrl!, options: [:], completionHandler: nil)
                    } else {
                        let success = UIApplication.shared.openURL(justQuotesUrl!)
                        print("Open \(justQuotesSchema): \(success)")
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/just-quotes-did-you-know/id1190672970?l=ru&ls=1&mt=8")!, options: [:], completionHandler: nil)
                    } else {
                        let success = UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/just-quotes-did-you-know/id1190672970?l=ru&ls=1&mt=8")!)
                        print("Open (https://itunes.apple.com/us/app/just-quotes-did-you-know/id1190672970?l=ru&ls=1&mt=8): \(success)")
                    }
                }
            case "celebrity":
                let justPeoplesSchema = "readmypeopleapp://"
                let justPeoplesUrl = URL(string: justPeoplesSchema)
                if UIApplication.shared.canOpenURL(justPeoplesUrl!) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(justPeoplesUrl!, options: [:], completionHandler: nil)
                    } else {
                        let success = UIApplication.shared.openURL(justPeoplesUrl!)
                        print("Open \(justPeoplesSchema): \(success)")
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/just-people-did-you-know/id1197390666")!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/just-people-did-you-know/id1197390666")!)
                    }
            }
            default:
                self.performSegue(withIdentifier: "FactsByCategorySegue", sender: selectCategory)
                break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FactsByCategorySegue" {
            let categoryDetailViewController: CategoryDetailViewController = segue.destination as! CategoryDetailViewController
            categoryDetailViewController.category = sender as? CategoryDataModel
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) -> Void {
        if segue.identifier == "unwindToViewController" {
            //let factVC: CategoryDetailViewController = segue.sourceViewController as! CategoryDetailViewController
            print("UNVIND SEGUE");
        }
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
