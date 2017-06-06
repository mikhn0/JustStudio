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
        shareView.insertSubview(blurredEffectView, belowSubview: shareButton)
        
        shareButton.addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
        
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
                        self.configurationViewControllers(facts!, typeVC: DataViewController.self)
                    }
                })
            }
        } else if randomFacts != nil {
           configurationViewControllers(randomFacts!, typeVC: DataViewController.self)
        } else if todayFacts != nil {
            configurationViewControllers(todayFacts!, typeVC: TodayDataViewController.self)
        }
        
        
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        pageViewController!.view.frame = pageViewRect
        pageViewController!.didMove(toParentViewController: self)
    }

    
    func configurationViewControllers<T:DataModelVCProtocol>(_ facts: Sequence?, typeVC vcType:T.Type) where T:UIViewController {
        modelController = ModelController<T>()
        modelController?.allFacts = facts
        modelController?.activityIndicator = activityIndicator
        var viewControllers = [T]()
        let startingViewController:T = modelController!.viewControllerAtIndex(0, storyboard: storyboard!)!
        viewControllers = [startingViewController]
        
        pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        pageViewController!.dataSource = modelController as? UIPageViewControllerDataSource
        addChildViewController(pageViewController!)
        view.insertSubview(pageViewController!.view, belowSubview: bannerView)
    }
    
    func shareAction(_ sender: UIButton) {
        // Check and see if the text field is empty
        
        catchEvent(withText: "SHARE_ACTION_CLICK")
        
        if pageViewController!.viewControllers!.count > 0 {
            let currentViewController:DataModelVCProtocol = pageViewController!.viewControllers?[0]//DataViewController
            let indexOfCurrentViewController = modelController?.indexOfViewController(currentViewController)
            
            let facts = modelController?.allFacts!
            if (facts?.countResults!)! > 0 && indexOfCurrentViewController! >= 0 {
                if let fact = facts?[byIndex: indexOfCurrentViewController!] as? FactDataProtocol, fact.image == "" {
                    // The text field is empty so display an Alert
                    displayAlert("Warning", message: "Enter something in the text field!")
                } else {
                    // We have contents so display the share sheet
                    displayShareSheet((facts?[byIndex: indexOfCurrentViewController!])!)
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

        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frame.width, height: view.frame.height-100), true, UIScreen.main.scale)
        self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-50), afterScreenUpdates: false)
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
    //var modelController: ModelController<T: UIViewController & DataModelVCProtocol>?;
//    var modelController: ModelController {
//        if _modelController == nil {
//            _modelController = ModelController()
//        }
//        return _modelController!
//    }

    
    var modelController: ModelControllerProtocol?//ModelController?
}

extension DataModelVCProtocol where Self:UIViewController {
    var viewController: UIViewController {
        return self
    }
}

protocol Wibbling:DataModelVCProtocol {}


struct SharingError:Error {
    var rawValue:String
    var localizedDescription:String {
        return rawValue
    }
}
