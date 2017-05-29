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
        cell.titleLabel.text = title
        
        cell.titleLabel.sizeToFit()
        
        if photoUrl != "" {
            if photoData != nil {
                cell.photoView.image = UIImage(data:photoData! as Data)
            } else {
                let url = URL(string: photoUrl)
                let urlWithService = "http://res.cloudinary.com/dvq3boovd/image/fetch/c_scale,w_100/"+photoUrl
                
                let urlService = URL(string: urlWithService)
                
                let task = URLSession.shared.dataTask(with: urlService!, completionHandler: { (data, response, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            cell.photoView.sd_setImage(with: url, placeholderImage: UIImage(data:data!))
                        }
                    }
                })
                task.resume()
            }
        }

    }
}
