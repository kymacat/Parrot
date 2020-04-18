//
//  ImageService.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

protocol IImagesService {
    func loadImages(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void)
    func loadImageForCell(imageUrl: String, completionHandler: @escaping (UIImage?, String, String?) -> Void)
}

class ImagesService : IImagesService {
    
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImages(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.ImagesRequests.imagesConfig()
        
        requestSender.send(requestConfig: requestConfig) { (result: Result<[ImageApiModel]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImageForCell(imageUrl: String, completionHandler: @escaping (UIImage?, String, String?) -> Void) {
        let requestConfig = RequestsFactory.ImagesRequests.imageConfig(imageUrl: imageUrl)
        
        requestSender.send(requestConfig: requestConfig) { (result: Result<Data>) in
            switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    completionHandler(image, imageUrl, nil)
                case .error(let error):
                    completionHandler(nil, imageUrl, error)
                }
        }
    }
}
