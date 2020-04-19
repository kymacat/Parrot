//
//  ImageCell.swift
//  Parrot
//
//  Created by Const. on 17.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

protocol IImageCellDelegate {
    func cacheImage(imageUrl: String, image: UIImage)
    func getImage(imageUrl: String, completionHandler: @escaping (UIImage?, String, String?) -> Void)
}

struct ImageCellModel {
    let imageUrl: String
}

class ImageCell: UICollectionViewCell, ConfigurableView {
    var delegate: IImageCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl = ""
    
    func configure(with model: ImageCellModel) {
        imageView.image = UIImage(named: "placeholder")
        imageUrl = model.imageUrl
        
        self.delegate?.getImage(imageUrl: model.imageUrl, completionHandler: {
            (image: UIImage?, url: String, error: String?) in
            if let image = image {
                DispatchQueue.main.async {
                    if self.imageUrl == url {
                        self.imageView.image = image
                        self.delegate?.cacheImage(imageUrl: url, image: image)
                    }
                }
                
            } else {
                if let error = error {
                    print(error)
                }
            }
        })
    }

}
