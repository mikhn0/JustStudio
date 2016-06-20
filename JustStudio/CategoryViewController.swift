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
    var categories: NSArray! = []
    var heightOfCell: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { // 1
            LibraryAPI.sharedInstance().getAllCategory ({ (categories: [CategoryData]) -> Void in
                self.categories = categories;
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
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
        
        let categoryData = categories[row] as! CategoryData
        cell.titleLabel.text = categoryData.ru
        
        if (categoryData.image_url != nil) {
            let url = NSURL(string: categoryData.image_url)
            cell.photoView.sd_setImageWithURL(url)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectCategory: CategoryData = categories[indexPath.row] as! CategoryData
        self.performSegueWithIdentifier("FactsByCategorySegue", sender: selectCategory)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FactsByCategorySegue" {
            let categoryDetailViewController: CategoryDetailViewController = segue.destinationViewController as! CategoryDetailViewController
            categoryDetailViewController.category = sender as? CategoryData
            
            //self.navigationController?.navigationBarHidden = false
            //self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
            //self.navigationController?.navigationBar.translucent = true
            
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) -> Void {
        if segue.identifier == "unwindToViewController" {
            let factVC: CategoryDetailViewController = segue.sourceViewController as! CategoryDetailViewController
            print("UNVIND SEGUE");
        }
    }
    
}