//
//  Firebase.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseRequests {
    
    func getChannels(reference: CollectionReference, for controller: ChannelsViewController)
    
    func addChannel(reference: CollectionReference, name: String, senderName: String)
    
    func getMessages(reference: CollectionReference, for controller: ChannelViewController)
    
    func sendMessage(reference: CollectionReference, message: MessageModel)
    
}

class Requests: FirebaseRequests {
    
    
    func getChannels(reference: CollectionReference, for controller: ChannelsViewController) {
        
        reference.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newChannels: [ChannelModel] = []
                for document in querySnapshot!.documents {
                    if let chanel = ChannelModel(identifier: document.documentID, with: document.data()) {
                        newChannels.append(chanel)
                    }
                }
                controller.updateChannels(with: newChannels)
            }
        }
        
    }
    
    func addChannel(reference: CollectionReference, name: String, senderName: String) {
        let document = reference.addDocument(data: ["name": name, "lastMessage": ""])
        let message = MessageModel(content: "\(senderName) создал новый канал", created: Date(), senderID: "123654", senderName: senderName)
        
        document.collection("messages").addDocument(data: message.toDict)
        
    }
    
    func getMessages(reference: CollectionReference, for controller: ChannelViewController) {
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
                DispatchQueue.main.async {
                    controller.updateMessages(with: newMessages)
                    
                }
                
            }
        }
    }
    
    func sendMessage(reference: CollectionReference, message: MessageModel) {
        reference.addDocument(data: message.toDict)
    }
}
