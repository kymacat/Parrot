//
//  IRequestSender.swift
//  Parrot
//
//  Created by Const. on 18.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model>) -> Void)
}
