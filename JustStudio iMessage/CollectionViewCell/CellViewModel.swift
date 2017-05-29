//
//  CellViewModel.swift
//  JustStudio
//
//  Created by a1 on 24.05.17.
//  Copyright © 2017 Imac. All rights reserved.
//

import Foundation

protocol CellViewModel {
    associatedtype CellType:UIView
    func setup(cell:CellType)
}

struct CategoryCellModel {
    let photoUrl:String
    let photoData:NSData?
    let title:String
}

struct FactCellModel {
    let photoUrl:String
    let photoData:NSData?
    let title:String
}

extension UITableView {
    func dequeueReusableCell<T:CellViewModel>(viewModel model:T, for indexPath:IndexPath) -> UITableViewCell {
        let identifier = String(describing: T.CellType.self)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? T.CellType {
            model.setup(cell: cell)
        } else {
            assertionFailure("Get cell incorrected type")
        }
        return cell
    }
}

extension CategoryCellModel:CellViewModel {
    
    func setup(cell: CategoryCell) {
        cell.categoryLabel.text = title
        if photoData != nil {
            cell.categoryImage.image = UIImage(data:photoData! as Data)
        } else {
            cell.categoryImage?.image = nil
            if (photoUrl != "") {
                let url = URL(string: photoUrl)
                let urlService = URL(string: "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/" + photoUrl)
                
                let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                    if error == nil {
                        cell.categoryImage?.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
                    }
                })
                task.resume()
            }
        }
        
    }
}

extension UICollectionView {
    func dequeueReusableCell<T:CellViewModel>(viewModel model:T, for indexPath:IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: T.CellType.self)
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = cell as? T.CellType {
            model.setup(cell: cell)
        } else {
            assertionFailure("Get cell incorrected type")
        }
        return cell
    }
}

extension FactCellModel: CellViewModel {
    func setup(cell: FactCell) {
        cell.descrFact.text = title
        cell.image_url = photoUrl
        if photoData != nil {
            cell.imageFact.image = UIImage(data:photoData! as Data)
        } else {
            cell.imageFact.image = nil
            if (photoUrl != "") {
                let url = URL(string: photoUrl)
                let betweenString = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/" + photoUrl
                let urlService = URL(string: betweenString)
                
                let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                    if error == nil {
                        cell.imageFact?.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
                    }
                })
                task.resume()
            }
        }
    }
}
