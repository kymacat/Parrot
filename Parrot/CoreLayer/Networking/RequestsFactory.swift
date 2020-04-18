//
//  RequestsFactory.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct ImagesRequests {
        static func imagesConfig() -> RequestConfig<ImagesParser> {
            let request = ImagesRequest(apiKey: "16093875-adcbf163144f82e25dc3cb60f")
            return RequestConfig<ImagesParser>(request: request, parser: ImagesParser())
        }
        
        static func imageConfig(imageUrl: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(imageUrl: imageUrl)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
