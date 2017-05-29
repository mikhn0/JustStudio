//
//  CategoryVC.swift
//  JustStudio
//
//  Created by nuSan_old_acc on 26.10.16.
//  Copyright © 2016 Imac. All rights reserved.
//

import Foundation
import Messages
import ImageIO
import SDWebImage
import RealmSwift

protocol CategoryVCDelegate: class {
    func tappedToAddNewsStickersToCollection (_ controller:CategoryVC)
    //Facts
    func buttonTappedOn(selectCategory: CategoryDataModel, onCell: UIImage)
}


class CategoryVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    static let storyboardIdentifier = "CategoryVC"
    weak var delegate:CategoryVCDelegate?
    
    var lastOpenVC:LastOpenVC = .categories
    @IBOutlet weak var topOfCategoryVC: NSLayoutConstraint!
    @IBOutlet weak var categoryTable:UITableView?

    var _categories: Results<CategoryDataModel>?
    var messagesViewController: MessagesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dequeueCategoryCell(for: _categories![indexPath.row], at:indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CategoryCell = tableView.cellForRow(at: indexPath) as! CategoryCell
        delegate?.buttonTappedOn(selectCategory:(_categories?[indexPath.row])!, onCell: cell.getScreenShortOfCell())
    }

//очередь для категории ячейки
    private func dequeueCategoryCell(for category: CategoryDataModel, at indexPath:IndexPath) -> UITableViewCell {
        let model = CategoryCellModel(photoUrl: category.image, photoData: category.image_view, title: returnDescriptionForApp(category))
        // messagesViewController._currentUpdateCategoryData = nil
        return categoryTable!.dequeueReusableCell(viewModel: model, for: indexPath)
    }
}

@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
 
            let firstLineStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            firstLineStyle.firstLineHeadIndent = 27
            firstLineStyle.tailIndent = 135
            firstLineStyle.alignment = .center
            
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSParagraphStyleAttributeName:firstLineStyle],
                                                                    context: nil).size
            
            super.drawText(in: CGRect(x:0,y: 0,width: frame.width, height:ceil(labelStringSize.height)))
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
