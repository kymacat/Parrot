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
    func getMessages(updatedVC: MessagesViewController)
    func sendMessage(message: String)
    func getSenderID() -> String
}

class MessagesVCModel : IMessagesVCModel {
    
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
    
    
    func getMessages(updatedVC: MessagesViewController) {
        messagesService.getMessages(channelIdentifier: channel.identifier, for: updatedVC)
    }
    
    func sendMessage(message: String) {
        let message = MessageModel(content: message, created: Date(), senderID: senderID, senderName: senderName)
        messagesService.sendMessage(message: message, channelIdentifier: channel.identifier)
    }
    
    func getSenderID() -> String {
        return senderID
    }
}
