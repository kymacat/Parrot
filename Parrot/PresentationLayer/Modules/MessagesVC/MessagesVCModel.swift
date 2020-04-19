//
//  MessagesVCModel.swift
//  Parrot
//
//  Created by Const. on 13.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import CoreData
import Firebase

protocol IMessagesVCModel {
    var delegate: IMessagesDelegate? { get set }
    func getMessages()
    func sendMessage(message: String)
    func getSenderID() -> String
    func groupMessages(messages: [MessageModel]) -> [[MessageModel]]
}

protocol IMessagesDelegate {
    func setup(with newMessages: [MessageModel])
}

class MessagesVCModel : IMessagesVCModel {
    
    var delegate: IMessagesDelegate?
    
    let messagesService: IMessagesService
    let senderName: String
    let senderID: String
    private var channel: ChannelModel
    
    
    init(messagesService: IMessagesService, channel: ChannelModel, senderName: String, senderID: String) {
        self.messagesService = messagesService
        self.senderName = senderName
        self.senderID = senderID
        self.channel = channel
    }
    
    
    func getMessages() {
        if let delegate = delegate {
            messagesService.getMessages(channelIdentifier: channel.identifier, completionHandler: delegate.setup(with:))
        }
    }
    
    func sendMessage(message: String) {
        let message = MessageModel(content: message, created: Date(), senderID: senderID, senderName: senderName)
        messagesService.sendMessage(message: message, channelIdentifier: channel.identifier)
    }
    
    func getSenderID() -> String {
        return senderID
    }
    
    func groupMessages(messages: [MessageModel]) -> [[MessageModel]] {
        return messagesService.groupMessages(newMessages: messages)
    }
}
