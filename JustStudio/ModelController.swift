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

protocol ModelControllerProtocol {
    var allFacts: Sequence? {get set}
    var activityIndicator: UIActivityIndicatorView? {get set}
    func viewControllerAtIndex<T:DataModelVCProtocol>(_ index: Int, storyboard: UIStoryboard) -> T?
    func indexOfViewController<T:DataModelVCProtocol>(_ viewController: T) -> Int
}

class ModelController<T>: NSObject, UIPageViewControllerDataSource, ModelControllerProtocol where T:DataModelVCProtocol, T:UIViewController {
    
    typealias TypePage = T
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
        if allFacts is [TodayProtocol] {
            return page(viewControllerBefore: viewController as! TodayDataViewController)
        } else {
            return page(viewControllerBefore: viewController as! DataViewController)
        }
        
    }
    
    func page<U:DataModelVCProtocol>(viewControllerBefore viewController: U) -> U? where U:UIViewController {
        var index = indexOfViewController(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index -= 1
        let vc:U = viewControllerAtIndex(index, storyboard: viewController.storyboard!)!
        return vc
    }
    

    
    func page<T:DataModelVCProtocol>(viewControllerAfter viewController: T) -> T? where T:UIViewController {
        var index = indexOfViewController(viewController)
        if index == NSNotFound {
            return nil
        }
        index += 1
        if index == allFacts?.countResults {
            return nil
        }
        let vc:T = viewControllerAtIndex(index, storyboard: viewController.storyboard!)!
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //let vc = viewController as! TypePage.Type
        return page(viewControllerAfter: viewController as! TodayDataViewController)
        //        return page(viewControllerAfter:viewController as? TypePage.Type)
        //        if allFacts is [TodayProtocol] {
        //            return page(viewControllerAfter: viewController as! TodayDataViewController)
        //        } else {
        //            return page(viewControllerAfter: viewController as! DataViewController)
        //        }
    }
}

