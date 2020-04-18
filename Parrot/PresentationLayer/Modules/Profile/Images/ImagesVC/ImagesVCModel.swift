//
//  ImagesVCModel.swift
//  Parrot
//
//  Created by Const. on 17.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import Foundation

struct CellDisplayModel {
    let imageUrl: String
}

protocol IImagesVCModel {
    var delegate: IImagesVCDelegate? { get set }
    func fetchImages()
}

protocol IImagesVCDelegate {
    func setup(dataSource: [CellDisplayModel])
}

class ImagesVCModel: IImagesVCModel {
    
    var delegate: IImagesVCDelegate?
    var imagesService: IImagesService
    
    init(imagesService: IImagesService) {
        self.imagesService = imagesService
    }
    
    func fetchImages() {
        imagesService.loadImages { (images: [ImageApiModel]?, error: String?) in
            if let images = images {
                let cells = images.map({ CellDisplayModel(imageUrl: $0.webformatURL) })
                self.delegate?.setup(dataSource: cells)
            } else {
                print(error ?? "")
            }
            
        }
    }
}

