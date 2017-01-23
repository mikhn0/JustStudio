//
//  CategoryViewController.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import SDWebImage

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "CategoryCell"
    var categories: [CategoryData]! = []
    var heightOfCell: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LibraryAPI.sharedInstance().getAllCategory ({ (categories: [CategoryData]) -> Void in
            if categories != [] {
                self.categories = categories;
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                for categ in self.categories {
                DispatchQueue.global().async {
                        print("START prepare image for \(categ.name)")
                        if categ.image == nil {
                            categ.image?.sd_setImage(with: URL(string: categ.image_url)!)
                        }
                        print("FINISHED prepare image for \(categ.name)")
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "System error.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                    // ...
                }
            }
        })
    
        tableView.delegate = self
        tableView.dataSource = self
        heightOfCell = (self.view.frame.size.height + 20) / 2
    }

    
    //#pragma - mark UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfCell
    }
    
    
    //#pragma - mark UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryCell(style: UITableViewCellStyle.value1, reuseIdentifier: textCellIdentifier)
        
        let row = (indexPath as NSIndexPath).row
        
        let categoryData = categories[row]
  
        cell.titleLabel.setDescription(dataObject: categoryData)

        cell.titleLabel.sizeToFit()
        
        if (categoryData.image_url != nil) {
            let url = URL(string: categoryData.image_url)
            let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"
            
            let urlService = URL(string: urlWithService+categoryData.image_url)
 
            let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                if error == nil {
                    cell.photoView.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
                }
            })
            task.resume()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCategory: CategoryData = categories[(indexPath as NSIndexPath).row]
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
            default:
                self.performSegue(withIdentifier: "FactsByCategorySegue", sender: selectCategory)
                break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FactsByCategorySegue" {
            let categoryDetailViewController: CategoryDetailViewController = segue.destination as! CategoryDetailViewController
            categoryDetailViewController.category = sender as? CategoryData
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) -> Void {
        if segue.identifier == "unwindToViewController" {
            //let factVC: CategoryDetailViewController = segue.sourceViewController as! CategoryDetailViewController
            print("UNVIND SEGUE");
        }
    }
    
    
}
