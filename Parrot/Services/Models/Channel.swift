//
//  Channel.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation


struct Channel {
    
    
    
    init(identifier: String, with data: [String: Any]) {
        guard
            let name = data["name"] as? String
            else {
                self.identifier = identifier
                self.lastMessage = ""
                self.name = ""
                return
        }
        
        self.identifier = identifier
        self.name = name
        
        if let lastMessage = data["lastMessage"] as? String {
            self.lastMessage = lastMessage
        } else {
            self.lastMessage = ""
        }
        
    }
    
    let identifier: String
    let name: String
    let lastMessage: String?
    
    var toDict: [String: Any] {
        if let message = lastMessage {
            return [
            "name": name,
            "lastMessage": message
            ]
        } else {
           return [
            "name": name,
            "lastMessage": ""
            ]
        }
    }
}
