//
//  ImageCell.swift
//  Parrot
//
//  Created by Const. on 17.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

struct CellDisplayModel {
    let imageUrl: String
}

class ImageCell: UICollectionViewCell, ConfigurableView {
    var model: IImagesVCModel?
    
    @IBOutlet weak var image: UIImageView!
    
    var imageUrl = ""
    
    func configure(with model: CellDisplayModel) {
        image.image = UIImage(named: "placeholder")
        imageUrl = model.imageUrl
        self.model?.getImageForCell(imageUrl: model.imageUrl, completionHandler: { (image: UIImage?, url: String, error: String?) in
            if let image = image {
                DispatchQueue.main.async {
                    if self.imageUrl == url {
                        self.image.image = image
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
