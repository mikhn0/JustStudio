//
//  RootViewController.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import GoogleMobileAds
import UIKit

class CategoryDetailViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareView: UIView!
    var pageViewController: UIPageViewController?
    var category: CategoryData?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.activityIndicator.startAnimating()
        
        self.shareView.layer.cornerRadius = 5
        let blurEffect = UIBlurEffect(style: .Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        var frame = self.shareView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        blurredEffectView.frame = frame
        self.shareView.insertSubview(blurredEffectView, belowSubview: self.shareButton)
        
        self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        
//        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
//        self.bannerView.adUnitID = "ca-app-pub-8295422108411344/2897372116"
//        self.bannerView.rootViewController = self
//        self.bannerView.loadRequest(GADRequest())
        
        LibraryAPI.sharedInstance().getFactsByCategory(self.category!.name!, completion:{ (facts: [FactData]) -> Void in
            
            self.ConfigurationViewControllers(facts)

        })
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
        }
        self.pageViewController!.view.frame = pageViewRect
        self.pageViewController!.didMoveToParentViewController(self)
        
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        //self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }

    func ConfigurationViewControllers(facts: [FactData]) -> Void {
        
        self.modelController.allFacts = facts;
        
        self.modelController.activityIndicator = self.activityIndicator
        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        
        
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
        self.pageViewController!.dataSource = self.modelController
        self.addChildViewController(self.pageViewController!)
        self.view.insertSubview(self.pageViewController!.view, aboveSubview: self.bannerView)
        
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        // Check and see if the text field is empty
        let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        
        if (self.modelController.allFacts[indexOfCurrentViewController].image_url == "") {
            // The text field is empty so display an Alert
            displayAlert("Warning", message: "Enter something in the text field!")
        } else {
            // We have contents so display the share sheet
            displayShareSheet(self.modelController.allFacts[indexOfCurrentViewController])
        }
    }

    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        return
    }
    
    func displayShareSheet(shareContent:FactData) {
        let siteUrl:NSURL! = NSURL.init(string: "https://justfacts.carrd.co/")
        let url = NSURL(string: shareContent.image_url)
        let imageView: UIImageView? = UIImageView.init()
        imageView!.sd_setImageWithURL(url)
        let shareImage: UIImage! = imageView?.image
        let activityViewController = UIActivityViewController(activityItems: [shareImage as UIImage, shareContent.ru as String, siteUrl as NSURL], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
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

    
}

