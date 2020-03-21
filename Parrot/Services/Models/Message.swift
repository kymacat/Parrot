//
//  Message.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderID: String
    let senderName: String
    
    init?(with data: [String: Any]) {
        guard
            let content = data["content"] as? String,
            let created = data["created"] as? Timestamp,
            let senderID = data["senderID"] as? String,
            let senderName = data["senderName"] as? String
            else {
                return nil
        }
        
        self.content = content
        self.created = created.dateValue()
        self.senderID = senderID
        self.senderName = senderName
    }
}

extension Message {
    var toDict:[String: Any] {
        return [
            "content": content,
            "created": Timestamp(date: created),
            "senderID": senderID,
            "senderName": senderName
         ]
    }
}
  
