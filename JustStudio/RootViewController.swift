//
//  RootViewController.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import GoogleMobileAds
import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    var pageViewController: UIPageViewController?
    var category: CategoryData?


    override func viewDidLoad() {
        super.viewDidLoad()
        print("version sdk ====== \(GADRequest.sdkVersion())")
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        self.bannerView.adUnitID = "ca-app-pub-9914727606483597/7269455068"
        self.bannerView.rootViewController = self
        self.bannerView.loadRequest(GADRequest())
        
        let backgroundQueue: dispatch_queue_t = dispatch_queue_create("com.a.identifier", DISPATCH_QUEUE_CONCURRENT)
        
        // can be called as often as needed
        dispatch_async(backgroundQueue) {
            if self.category != nil {
                LibraryAPI.sharedInstance().getFactsByCategory(self.category!.id, completion:{ (facts: [FactData]) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.modelController.allFacts = facts;
                        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
                        
                        let viewControllers = [startingViewController]
                        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
                        self.pageViewController!.dataSource = self.modelController
                        self.addChildViewController(self.pageViewController!)
                        self.view.insertSubview(self.pageViewController!.view, belowSubview: self.bannerView)
                        //self.view.addSubview(self.pageViewController!.view)
                    }
                    
                })
            } else {
                
                LibraryAPI.sharedInstance().getAllFacts( { (facts: [FactData]) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.modelController.allFacts = facts;
                        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
                        
                        let viewControllers = [startingViewController]
                        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
                        self.pageViewController!.dataSource = self.modelController
                        self.addChildViewController(self.pageViewController!)
                        print("count view == \(self.view.subviews.count)");
                        self.view.insertSubview(self.pageViewController!.view, belowSubview: self.bannerView)
                        //self.view.addSubview(self.pageViewController!.view)
                        print("count view == \(self.view.subviews.count)");
                    }
                })
            }
        }
        
        


        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect

        self.pageViewController!.didMoveToParentViewController(self)

        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods

    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

            self.pageViewController!.doubleSided = false
            return .Min
        }

        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

        return .Mid
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            self.navigationController?.navigationBarHidden = true
        }
    }
}

