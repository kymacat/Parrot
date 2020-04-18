//
//  ImagesRequest.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

class ImagesRequest: IRequest {
    private var baseUrl: String = "https://pixabay.com/api/"
    private let apiKey: String
    private let perPage = "99"
    private var getParameters: [String : String]  {
        return ["key": apiKey,
                "per_page": perPage]
    }
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseUrl + "?" + getParams
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
    // MARK: - Initialization

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
