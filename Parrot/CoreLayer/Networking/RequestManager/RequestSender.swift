//
//  RequestsSender.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

class RequestSender : IRequestSender {
    
    let session = URLSession.shared
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        
        guard let urlRequest = requestConfig.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = requestConfig.parser.parse(data: data) else {
                    completionHandler(Result.error("received data can't be parsed"))
                    return
            }
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
        
    }
    
}
