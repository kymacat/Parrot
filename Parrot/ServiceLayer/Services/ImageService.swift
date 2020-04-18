//
//  ImageService.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

protocol IImagesService {
    func loadImages(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void)
}

class ImagesService : IImagesService {
    
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImages(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.ImagesRequests.imageConfig()
        
        requestSender.send(requestConfig: requestConfig) { (result: Result<[ImageApiModel]>) in
            switch result {
            case .success(let images):
                completionHandler(images, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
