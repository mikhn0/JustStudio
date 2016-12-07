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

class MessagesViewController: MSMessagesAppViewController, CompactVCDelegate, AddStickersVCDelegate
{
    
    var compactVC : CompactVC!
    var addStickersVC: AddStickersVC?
    var previewVC: PreviewVC!
    
    var _fact:[Facts] = []
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
            presentCompactVC()
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
        if presentationStyle == .expanded && messageSelectFromConversation == false || activeConversation?.selectedMessage == nil && presentationStyle == .expanded {
            
            presentAddStickersVC()
            
        } else if presentationStyle == .compact && messageSelectFromConversation == false || activeConversation?.selectedMessage == nil && presentationStyle == .compact {
            
            presentCompactVC ()
            NotificationCenter.default.post (name: NSNotification.Name (rawValue: "OpenScreenWithCompactsStyle"), object: nil)
            
        } else {
            
            presentPreview ()
            
        }
        
    }
    
    //pragma mark - CompactVCDelegate
    
    func tappedToADDNewsStickersToCollection(_ controller: CompactVC) {
        messageSelectFromConversation = false
        openExpandedStyle()
    }
    
    
    //pragma mark - AddStickersVCDelegate
    
    func chooseStickerToAddToCollection(_ screenShot: UIImage, with fact: Facts) {
    

    }
    
    
    //pragma mark - present different VC
    
    func presentAddStickersVC() {
        if addStickersVC == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: AddStickersVC.storyboardIdentifier) as? AddStickersVC
            addStickersVC = controller
            addStickersVC?.delegate = self
        }
        
        addStickersVC?.view.frame = self.view.frame
        self.addChildViewController(addStickersVC!)
        addStickersVC?.didMove(toParentViewController: self)
        self.view.addSubview((addStickersVC?.view)!)
        compactVC.removeFromParentViewController()
        previewVC?.removeFromParentViewController()
        
    }
    
    func presentPreview() {
        if previewVC == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: PreviewVC.storyboardIdentifier) as? PreviewVC
            
            previewVC = controller
            let fact = Facts (message: activeConversation?.selectedMessage)
            
            let item = try Facts (desc: (fact?.desc)!, image: (fact?.image)! )
            previewVC.item = item
        }
        
        previewVC.view.frame = self.view.frame
        self.addChildViewController(previewVC!)
        previewVC.didMove (toParentViewController: self)
        self.view.addSubview((previewVC?.view)!)
        messageSelectFromConversation = false
        compactVC.removeFromParentViewController()
        compactVC.view.isHidden = true
        addStickersVC?.removeFromParentViewController()
        addStickersVC?.view.isHidden = true
    }
    
    func presentCompactVC() {
        if compactVC == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: CompactVC.storyboardIdentifier) as? CompactVC
            
            compactVC = controller
            compactVC.delegate = self
            
            uploadCategories()
            
        }
        
        compactVC.view.frame = self.view.frame
        self.addChildViewController(compactVC)
        compactVC.didMove(toParentViewController: self)
        self.view.addSubview(compactVC.view)
        
        compactVC.factCollection?.reloadData()
        compactVC.categoryCollection?.reloadData()
        compactVC.changeBrowserViewBackgroundColor(color: UIColor.init(red:1.0, green:1.0, blue:1.0, alpha:1))
        
        addStickersVC?.removeFromParentViewController()
        previewVC?.removeFromParentViewController()
    }
    
    
    //pragma mark - Inspection Stickers to match
    
    func checkNewSticker(newFact:Facts) -> Bool {
        for elem in _fact {
            if elem.desc == newFact.desc
            {
                return true
            }
        }
        return false
    }
    
    
    //pragma mark - select one of the cells
    
    func buttonTappedOn(selectFact: Facts, onCell: UIImage) {
        
        guard let conversation = activeConversation else {fatalError()}
        let session = conversation.selectedMessage?.session ?? MSSession()
        
        let message = MSMessage(session:session)
        let layout = MSMessageTemplateLayout()
        layout.subcaption = " Just Studio"
        layout.image = onCell
        
        message.layout = layout
        
        var components = URLComponents()
        components.queryItems = selectFact.queryItems
        message.url = components.url
        
        conversation.insert(message) { error in
            if (error) != nil { print(error) }
        }
    }


    
    func uploadCategories() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
        
            LibraryWatchAPI.sharedInstance().getAllCategoryForWatch { (categories) in
                
                LibraryWatchAPI.sharedInstance().getFactsByCategoryForWatch(categories[0].name, completion:{ (facts) in
                    
                    //Prepare categories for display on compact VC
                    self.compactVC._categories = categories
     
                    
/*                    // Prepare Facts for display on compact VC
                    for elem in facts {
                        let factNewObject = Facts(desc: elem.en, image:elem.image)
                        
                        self._fact.append(factNewObject)
                        self.compactVC.factItems.append(.sticker(factNewObject))
                    }
*/
                    
                   DispatchQueue.main.async {
                        self.compactVC.factCollection?.reloadData()
                        self.compactVC.categoryCollection?.reloadData()
                    }
                    
                })
                
            }
        }
    }


    
    
    func openExpandedStyle() {
        requestPresentationStyle(.expanded)
    }
    
    func openCompactStyle() {
        requestPresentationStyle(.compact)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
