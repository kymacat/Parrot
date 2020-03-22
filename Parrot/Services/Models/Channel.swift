//
//  Channel.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

struct Channel {
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let activeDate: Date?
    
    init?(identifier: String, with data: [String: Any]) {
        guard
            let name = data["name"] as? String
            else {
                return nil
        }
        
        self.identifier = identifier
        self.name = name
        
        if let lastMessage = data["lastMessage"] as? String {
            self.lastMessage = lastMessage
        } else {
            self.lastMessage = nil
        }
        
        if let date = data["lastActivity"] as? Timestamp {
            self.activeDate = date.dateValue()
        } else {
            self.activeDate = nil
        }
    }
    
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
