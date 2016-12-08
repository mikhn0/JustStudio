//
//  MessagesViewController.swift
//  JustStudio iMessage
//
//  Created by nuSan_old_acc on 26.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import UIKit
import Foundation
import Messages

class MessagesViewController: MSMessagesAppViewController, CategoryVCDelegate, FactsVCDelegate
{

    var categoryVC : CategoryVC!
    var factsVC: FactsVC?
    var previewVC: PreviewVC!
    
    var _fact:[FactData] = []
    var savedConversation: MSConversation?
    var messageSelectFromConversation = false
    
    var messageImage: UIImage? {
        guard let image = UIImage (named: "app") else {return nil}
        let rect = CGRect (x:0, y:0, width: image.size.width, height: image.size.height)
        
        let render = UIGraphicsImageRenderer (bounds: rect)
        return render.image {context in
            let bgColor: UIColor = UIColor.black
            bgColor.setFill()
            context.fill (rect)
            image.draw(at: .zero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self._fact.count == 0 {
            presentCategoryVC()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.openExpandedStyle), name: NSNotification.Name(rawValue: "OpenScreenWithExpectedStyle"), object: nil)
    }
    
    
    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        super.willSelect(message, conversation: conversation)
        print("willSelect")
        messageSelectFromConversation = true
    }
    
    
    override func willTransition (to presentationStyle: MSMessagesAppPresentationStyle) {
        super.willTransition(to: presentationStyle)
        if presentationStyle == .expanded && messageSelectFromConversation == true && activeConversation?.selectedMessage != nil && presentationStyle == .expanded {
            
            presentPreview ()
            
        } else if presentationStyle == .expanded && messageSelectFromConversation == false || activeConversation?.selectedMessage == nil && presentationStyle == .expanded {
            
            //presentFactsVC()
            messageSelectFromConversation = false
            categoryVC.topOfCategoryVC.constant = 85
            print("messageSelectFromConversation = \(messageSelectFromConversation)")
            
        } else if presentationStyle == .compact && messageSelectFromConversation == false || activeConversation?.selectedMessage == nil && presentationStyle == .compact {
            
            messageSelectFromConversation = false
            categoryVC.topOfCategoryVC.constant = 0
            presentCategoryVC ()
            NotificationCenter.default.post (name: NSNotification.Name (rawValue: "OpenScreenWithCompactsStyle"), object: nil)
            
        }
        
    }
    
    
    //pragma mark - CompactVCDelegate
    
    func tappedToAddNewsStickersToCollection(_ controller: CategoryVC) {
        messageSelectFromConversation = false
        openExpandedStyle()
    }
    
    func buttonTappedOn(selectCategory: CategoryData, onCell: UIImage) {
        print("buttonTappedOn method of protocol")
        openExpandedStyle()
        presentFactsVC(by: selectCategory.name)
    }
    
    
    //pragma mark - AddStickersVCDelegate
    
    func chooseFactForSend(_ screenShot: UIImage, with fact: Facts) {
        guard let conversation = activeConversation else {fatalError()}
        let session = conversation.selectedMessage?.session ?? MSSession()
        
        let message = MSMessage(session:session)
        let layout = MSMessageTemplateLayout()
        layout.subcaption = " Just Facts: Did You Know?"
        layout.image = screenShot
        
        message.layout = layout
        
        var components = URLComponents()
        components.queryItems = fact.queryItems
        message.url = components.url
        
        conversation.insert(message) { error in
            if (error) != nil { print(error ?? "ERROR") }
        }
        openCompactStyle()
    }
    
    
    //pragma mark - present different VC
    
    func presentFactsVC(by category:String) {
        if factsVC == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: FactsVC.storyboardIdentifier) as? FactsVC
            factsVC = controller
            factsVC?.delegate = self
            
            factsVC?.view.frame = self.view.frame
            self.addChildViewController(factsVC!)
            factsVC?.didMove(toParentViewController: self)
            self.view.addSubview((factsVC?.view)!)
        }
        
        uploadFacts(by: category)
        factsVC?.collectionView.reloadData()

        
        factsVC?.view.isHidden = false
        //categoryVC.removeFromParentViewController()
        categoryVC.view.isHidden = true
        //previewVC?.removeFromParentViewController()
        previewVC?.view.isHidden = true
    }
    
    func presentPreview() {
        if previewVC == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: PreviewVC.storyboardIdentifier) as? PreviewVC
            
            previewVC = controller
            let fact = Facts (message: activeConversation?.selectedMessage)
            
            let item = Facts (desc: (fact?.desc)!, image: (fact?.image)! )
            previewVC.item = item
            
            previewVC.view.frame = self.view.frame
            self.addChildViewController(previewVC!)
            previewVC.didMove (toParentViewController: self)
            self.view.addSubview((previewVC?.view)!)
        }
        messageSelectFromConversation = false
        
        previewVC.view.isHidden = false
        //categoryVC.removeFromParentViewController()
        categoryVC.view.isHidden = true
        //factsVC?.removeFromParentViewController()
        factsVC?.view.isHidden = true
    }
    
    func presentCategoryVC() {
        if categoryVC == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: CategoryVC.storyboardIdentifier) as? CategoryVC
            categoryVC = controller
            categoryVC.delegate = self
            uploadCategories()
            
            categoryVC.view.frame = self.view.frame
            self.addChildViewController(categoryVC)
            categoryVC.didMove(toParentViewController: self)
            self.view.addSubview(categoryVC.view)
        }
        
        categoryVC.categoryTable?.reloadData()
        categoryVC.changeBrowserViewBackgroundColor(color: UIColor.init(red:1.0, green:1.0, blue:1.0, alpha:1))
        
        categoryVC.view.isHidden = false
        //factsVC?.removeFromParentViewController()
        factsVC?.view.isHidden = true
       // previewVC?.removeFromParentViewController()
        previewVC?.view.isHidden = true
    }
    
    
    //pragma mark - Inspection Stickers to match
    
    func checkNewSticker(newFact:FactData) -> Bool {
        for elem in _fact {
            if elem.en == newFact.en
            {
                return true
            }
        }
        return false
    }
    
    func uploadCategories() {
        LibraryAPI.sharedInstance().getAllCategory ({ (categories: [CategoryData]) -> Void in
            if categories != [] {
                self.categoryVC._categories = categories;
                DispatchQueue.main.async {
                    self.categoryVC.categoryTable?.reloadData()
                }
                
                for categ in categories {
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
    }

    func uploadFacts(by category:String) {
        LibraryAPI.sharedInstance().getFactsByCategory(category, completion:{ (facts: [FactData]) -> Void in
            
            if facts != [] {
                self.factsVC?.facts = facts
            }
            DispatchQueue.main.async {
                self.factsVC?.collectionView?.reloadData()
            }
        })
    }
    
    func openExpandedStyle() {
        if presentationStyle == .compact {
            requestPresentationStyle(.expanded)
        }
    }
    
    func openCompactStyle() {
        if presentationStyle == .expanded {
            requestPresentationStyle(.compact)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
