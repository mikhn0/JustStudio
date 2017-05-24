//
//  ModelController.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

class ModelController: NSObject, UIPageViewControllerDataSource {
    
    var allFacts: Sequence?
    var activityIndicator: UIActivityIndicatorView?

    override init() {
        super.init()
    }

    func viewControllerAtIndex<T:DataModelVCProtocol>(_ index: Int, storyboard: UIStoryboard) -> T? {
        // Return the data view controller for the given index.

        if (allFacts?.countResults == 0) || (index >= (allFacts?.countResults)!) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        var dataViewController = storyboard.instantiateViewController(withIdentifier: (allFacts is [TodayProtocol] ? "TodayDataViewController" : "DataViewController")) as! T
        dataViewController.dataObject = allFacts?[byIndex: index] as? T.Item
        dataViewController.activityIndicator = activityIndicator
        return dataViewController
    }

    func indexOfViewController<T:DataModelVCProtocol>(_ viewController: T) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        var indexOfFact: Int = NSNotFound
        for index in 0..<allFacts!.countResults! {
            let factData = allFacts![byIndex: index]
            if factData._id == (viewController.dataObject as! BaseDataProtocol)._id {
                indexOfFact = index
                break
            }
        }
        return indexOfFact
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = 0
        let isTodayFactDataModel = allFacts is [Today]
        index = !isTodayFactDataModel ? indexOfViewController(viewController as! DataViewController) : indexOfViewController(viewController as! TodayDataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        if !isTodayFactDataModel {
            let vc:DataViewController = viewControllerAtIndex(index, storyboard: viewController.storyboard!)!
            return vc
        } else {
            let vc:TodayDataViewController = viewControllerAtIndex(index, storyboard: viewController.storyboard!)!
            return vc
        }
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = 0
        let isTodayFactDataModel = allFacts is [Today]
        if !isTodayFactDataModel {
            index = indexOfViewController(viewController as! DataViewController)
        } else {
            index = indexOfViewController(viewController as! TodayDataViewController)
        }
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == allFacts?.countResults {
            return nil
        }
        if !isTodayFactDataModel {
            let vc:DataViewController = viewControllerAtIndex(index, storyboard: viewController.storyboard!)!
            return vc
        } else {
            let vc:TodayDataViewController = viewControllerAtIndex(index, storyboard: viewController.storyboard!)!
            return vc
        }
    }

}

