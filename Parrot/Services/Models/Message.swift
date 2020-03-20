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
  
