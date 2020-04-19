//
//  Firebase.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

protocol IChannelsFirebaseRequests {
    
    func getChannels(reference: CollectionReference, completionHandler: @escaping ([ChannelModel]) -> Void)
    
    func addChannel(reference: CollectionReference, name: String, senderName: String, senderID: String)
    
    func deleteChannel(reference: CollectionReference, with identifier: String)
    
}

protocol IMessagesFirebaseRequests {
    func getMessages(reference: CollectionReference, completionHandler: @escaping ([MessageModel]) -> Void)
    
    func sendMessage(reference: CollectionReference, message: MessageModel)
}

class ChannelRequests: IChannelsFirebaseRequests {
    
    func getChannels(reference: CollectionReference, completionHandler: @escaping ([ChannelModel]) -> Void) {
        reference.addSnapshotListener {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newChannels: [ChannelModel] = []
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        if let chanel = ChannelModel(identifier: document.documentID, with: document.data()) {
                            newChannels.append(chanel)
                        }
                    }
                    completionHandler(newChannels)
                }
            }
        }
    }
    
    func addChannel(reference: CollectionReference, name: String, senderName: String, senderID: String) {
        let document = reference.addDocument(data: ["name": name, "lastMessage": ""])
        let message = MessageModel(content: "\(senderName) создал новый канал", created: Date(), senderID: senderID, senderName: senderName)
        
        document.collection("messages").addDocument(data: message.toDict)
        
    }
    
    func deleteChannel(reference: CollectionReference, with identifier: String) {
        reference.document(identifier).delete()
    }
}

class MessagesRequests: IMessagesFirebaseRequests {
    
    func getMessages(reference: CollectionReference, completionHandler: @escaping ([MessageModel]) -> Void) {
        reference.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newMessages: [MessageModel] = []
                for document in querySnapshot!.documents {
                    if let message = MessageModel(with: document.data()) {
                        newMessages.append(message)
                    }
                }
                completionHandler(newMessages)
                
            }
        }
    }
    
    func sendMessage(reference: CollectionReference, message: MessageModel) {
        reference.addDocument(data: message.toDict)
    }
}
