//
//  ChannelModel.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

struct ChannelModel: Equatable {
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let activeDate: Date?
    var isActive: Bool
    
    init(identifier: String, name: String, lastMessage: String?, activeDate: Date?) {
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.activeDate = activeDate
        if let date = activeDate {
            if date > Date() - (60*10) {
                self.isActive = true
            } else {
                self.isActive = false
            }
            
        } else {
            self.isActive = false
        }
    }
    
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
            if date.dateValue() > Date() - (60*10) {
                isActive = true
            } else {
                isActive = false
            }
            
        } else {
            self.activeDate = nil
            isActive = false
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
    
    static func ==(lhs: ChannelModel, rhs: ChannelModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

