//
//  JustStudioCollectionVC.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 26.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages
import ImageIO

protocol CompactVCDelegate: class {
    func tappedToADDNewsStickersToCollection (_ controller:CompactVC)
    //Facts
    func buttonTappedOn(selectFact: Category, onCell: UIImage)
    }


class CompactVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

//    var factItems: [FactCollectionItem]! = []
    var categoryItems: [CategoryCollectionItem]! = []
    var timer: Timer?
    
    
    
    static let storyboardIdentifier = "CompactVC"
    weak var delegate:CompactVCDelegate?
    
    @IBOutlet weak var factCollection:UICollectionView?
    @IBOutlet weak var categoryCollection:UICollectionView?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

    var _facts: [Facts] = []
    var _categories: [Category] = []
    
    override func viewDidLoad() {
        
        activityIndicator?.hidesWhenStopped = true;
        activityIndicator?.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator?.center = view.center;
        activityIndicator?.startAnimating()
        
        super.viewDidLoad()
        
        //FactCollectionItem
//        factItems = [factCollection]()
        categoryItems = [categoryCollection]()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false, block: { (timer) in
            self.activityIndicator?.stopAnimating()
            let alertController = UIAlertController(title: "Error", message: "Some little cockroaches ate your Internet", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func changeBrowserViewBackgroundColor(color: UIColor) {
        self.factCollection?.backgroundColor = color
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return _categories.count
        }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width:(view.frame.size.width - 40.0) / 4, height:(view.frame.size.width - 40.0) / 4)
        }
        
    
    
    //обработка загрузка фактов
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        activityIndicator?.stopAnimating()
        

            let item = categoryItems[indexPath.row]
            switch item {
            case .sticker(let fact):
                
                self.timer?.invalidate()
                
                return dequeueCategoryCell(for: fact, at:indexPath)
                
            case .moresticker:
                
                return dequeueCategoryCell(for: _categories[indexPath.row], at:indexPath)
                
            }
            
            
    
        }
    }
    
    //обработка при нажатии категории
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let item = categoryItems[indexPath.row]
            switch item {
                
            case .sticker(let Category):
                let cell:CategoryCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
                
                delegate?.buttonTappedOn(selectFact: Category, onCell: cell.getScreenShortOfCell())
                
            case .moresticker:
                
                delegate?.tappedToADDNewsStickersToCollection(self)
            
            
           print("category")
           
            }
        }


//очередь для фактовой ячейки
/*    private func dequeueFactCell(for fact: Facts, at indexPath:IndexPath) -> UICollectionViewCell {
        let cell = factCollection?.dequeueReusableCell(withReuseIdentifier: FactCell.reuseIdentifier!, for: indexPath) as! FactCell
        cell.descrLabel.text = fact.desc
        //cell.image?.image = fact.image
        addGestureForEachCell(cell)
        return cell
    }
*/


//очередь для категории ячейки
    private func dequeueCategoryCell(for category: Category, at indexPath:IndexPath) -> UICollectionViewCell {
        let cell = categoryCollection?.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier!, for: indexPath) as! CategoryCell
        cell.categoryLabel?.text = category.name
        //cell.image?.image = category.image
        addGestureForEachCell(cell)
        return cell
    }


//(fact: Facts)
    func addStickerToCollectionView(category: Category) {
        categoryItems.insert(.sticker(category), at: 1)
    }









@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            
            print(stringText)
            
            let firstLineStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            firstLineStyle.firstLineHeadIndent = 27
            firstLineStyle.tailIndent = 135
            firstLineStyle.alignment = .center
            
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSParagraphStyleAttributeName:firstLineStyle],
                                                                    context: nil).size
            
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    
    func setTextWithCustomAttribute(text:String) {
        
        self.attributedText = prepareCustomAttribute(text: text)
        
    }
    
    func prepareCustomAttribute(text: String) -> NSMutableAttributedString {
        //Creating first Line Paragraph Style
        let firstLineStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        firstLineStyle.firstLineHeadIndent = 27
        firstLineStyle.tailIndent = 135
        firstLineStyle.alignment = .center
        
        //Creating Rest of Text Paragraph Style
        let restOfTextStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        firstLineStyle.tailIndent = 145
        restOfTextStyle.alignment = .center
        
        //Other settings if needed
        
        let fullLengthOfString = text.characters.count
        //Creating the NSAttributedString
        let lengthFirstString = 20 > fullLengthOfString ? fullLengthOfString : 20
        
        let rangeOfFirstLine = NSMakeRange(0, lengthFirstString)
        
        let attributedString:NSMutableAttributedString = NSMutableAttributedString.init(string: text)
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: firstLineStyle, range: rangeOfFirstLine)
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: restOfTextStyle, range: NSMakeRange(rangeOfFirstLine.location+rangeOfFirstLine.length, text.characters.count-(rangeOfFirstLine.location+rangeOfFirstLine.length)))
        return attributedString
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
