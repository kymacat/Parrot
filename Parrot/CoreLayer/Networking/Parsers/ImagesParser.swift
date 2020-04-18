//
//  ImagesParser.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

struct ImageApiModel : Codable {
    let id: Int
    let webformatURL: String
}

struct ImagesResponse : Codable {
    let hits: [ImageApiModel]
}

class ImagesParser: IParser {
    typealias Model = [ImageApiModel]
    
    func parse(data: Data) -> [ImageApiModel]? {
        let imageResponse = try? JSONDecoder().decode(ImagesResponse.self, from: data)
        let images = imageResponse?.hits
    
        return images
    }
}
