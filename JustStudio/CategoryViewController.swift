//
//  CategoryViewController.swift
//  JustStudio
//
//  Created by Виктория on 13.01.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "CategoryCell"
    var categories: [CategoryData]! = []
    var heightOfCell: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { // 1
            LibraryAPI.sharedInstance().getAllCategory ({ (categories: [CategoryData]) -> Void in
                if categories != [] {
                    self.categories = categories;
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                    
                    for categ in self.categories {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            print("start prepare image for \(categ.name)")
                            let data = NSData(contentsOfURL: NSURL(string: categ.image_url)!)
                            categ.image = UIImage(data:data!)
                            print("finished prepare image for \(categ.name)")
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: "System error.", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        // ...
                    }
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
            })
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        heightOfCell = (self.view.frame.size.height+20) / 2
    }

    
    //#pragma - mark UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightOfCell
    }
    
    
    //#pragma - mark UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CategoryCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: textCellIdentifier)
        
        let row = indexPath.row
        
        let categoryData = categories[row]
        cell.titleLabel.text = categoryData.ru
        
        if (categoryData.image_url != nil) {
            print("IndexPath.row === \(row)")
            let url = NSURL(string: categoryData.image_url)
            cell.photoView.sd_setImageWithURL(url, placeholderImage: categoryData.image)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectCategory: CategoryData = categories[indexPath.row] 
        self.performSegueWithIdentifier("FactsByCategorySegue", sender: selectCategory)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FactsByCategorySegue" {
            let categoryDetailViewController: CategoryDetailViewController = segue.destinationViewController as! CategoryDetailViewController
            categoryDetailViewController.category = sender as? CategoryData
            
            
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) -> Void {
        if segue.identifier == "unwindToViewController" {
            let factVC: CategoryDetailViewController = segue.sourceViewController as! CategoryDetailViewController
            print("UNVIND SEGUE");
        }
    }
    
}