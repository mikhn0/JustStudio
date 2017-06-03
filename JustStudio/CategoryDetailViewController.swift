//
//  RootViewController.swift
//  JustStudio
//
//  Created by Imac on 01.12.15.
//  Copyright © 2015 Imac. All rights reserved.
//

import GoogleMobileAds
import UIKit
import RealmSwift
import Realm
import YandexMobileMetrica


class CategoryDetailViewController: UIViewController, UIPageViewControllerDelegate {

    var category: CategoryDataModel?
    var randomFacts: [FactDataProtocol]?
    var todayFacts: [TodayProtocol]?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareView: UIView!
    var pageViewController: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        activityIndicator.startAnimating()
        
        shareView.layer.cornerRadius = 5
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        var frame = self.shareView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        blurredEffectView.frame = frame
        self.shareView.insertSubview(blurredEffectView, belowSubview: self.shareButton)
        
        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        self.bannerView.adUnitID = "ca-app-pub-8295422108411344/4374105316"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        
        if category != nil {
            if category!.name == "favorites" {
            } else {
                LibraryAPI.sharedInstance().getFactsByCategory(self.category!, completion:{ (facts: Results<FactDataModel>?) -> Void in
                    
                    DispatchQueue.main.async {
                        self.configurationViewControllers(facts!, typeVC: DataViewController())
                    }
                })
            }
        } else if randomFacts != nil {
           configurationViewControllers(randomFacts!, typeVC: DataViewController())
        } else if todayFacts != nil {
            configurationViewControllers(todayFacts!, typeVC: TodayDataViewController())
        }
        
        
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        pageViewController!.view.frame = pageViewRect
        pageViewController!.didMove(toParentViewController: self)
    }

    
    func configurationViewControllers<T>(_ facts: Sequence?, typeVC vcType:T) where T : UIViewController, T : DataModelVCProtocol{

        modelController.allFacts = facts
        modelController.activityIndicator = activityIndicator
        var viewControllers = [AnyObject]()
        if vcType is DataViewController {
            let startingViewController:DataViewController = modelController.viewControllerAtIndex(0, storyboard: storyboard!)!
            viewControllers = [startingViewController]
            
        } else {
            let startingViewController:TodayDataViewController = modelController.viewControllerAtIndex(0, storyboard: storyboard!)!
            viewControllers = [startingViewController]
        }
        pageViewController!.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: {done in })
        pageViewController!.dataSource = modelController
        addChildViewController(pageViewController!)
        view.insertSubview(pageViewController!.view, belowSubview: bannerView)
    }
    
    @IBAction func shareAction(_ sender: AnyObject) {
        // Check and see if the text field is empty
        
        catchEvent(withText: "SHARE_ACTION_CLICK")
        
        if self.pageViewController!.viewControllers!.count > 0 {
            let currentViewController = pageViewController!.viewControllers![0] as! DataViewController
            let indexOfCurrentViewController = modelController.indexOfViewController(currentViewController)
            
            let facts = modelController.allFacts!
            if facts.countResults! > 0 && indexOfCurrentViewController >= 0 {
                if let fact = facts[byIndex: indexOfCurrentViewController] as? FactDataProtocol, fact.image == "" {
                    // The text field is empty so display an Alert
                    displayAlert("Warning", message: "Enter something in the text field!")
                } else {
                    // We have contents so display the share sheet
                    displayShareSheet(facts[byIndex: indexOfCurrentViewController])
                }
            }
        }

    }

    func displayAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        return
    }
    
    func displayShareSheet(_ shareContent:BaseDataProtocol) {
        
        let siteUrl:URL! = URL(string: "https://justfacts.carrd.co/")

        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height-100), true, UIScreen.main.scale)
        self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-50), afterScreenUpdates: false)
        let shareImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [cropImage(image: shareImage, toRect: CGRect(x: 0, y: 140, width: shareImage.size.width*3, height: shareImage.size.height*3)), siteUrl as URL], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                catchEvent(withText: "SHARE_FACT_IN_\(String(describing: activity?.rawValue))")
            } else {
                catchError(withText: error ?? SharingError(rawValue:"SHARING"))
            }
            
        }
    }
    
    func cropImage(image:UIImage, toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    
    var _modelController: ModelController?

    
    // MARK: - UIPageViewController delegate methods

    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

            self.pageViewController!.isDoubleSided = false
            return .min
        }

        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

        return .mid
    }
}

struct SharingError:Error {
    var rawValue:String
    var localizedDescription:String {
        return rawValue
    }
}
