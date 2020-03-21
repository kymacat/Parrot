//
//  Firebase.swift
//  Parrot
//
//  Created by Const. on 20.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

class FirebaseRequests {
    
    static func getChannels(reference: CollectionReference, for controller: ChannelsViewController) {
        
        reference.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newChannels: [Channel] = []
                for document in querySnapshot!.documents {
                    if let chanel = Channel(identifier: document.documentID, with: document.data()) {
                        newChannels.append(chanel)
                    }
                    
                }
                DispatchQueue.main.async {
                    controller.updateChannels(with: newChannels)
                }
                
            }
        }
        
    }
    
    static func addChannel(reference: CollectionReference, name: String, senderName: String) {
        let document = reference.addDocument(data: ["name": name, "lastMessage": ""])
        if let message = Message(with: [
            "content": "\(senderName) создал канал",
            "created": Timestamp(date: Date()),
            "senderID": "123654",
            "senderName": senderName
        ]) {
            document.collection("messages").addDocument(data: message.toDict)
        }
    }
    
    static func getMessages(reference: CollectionReference, for controller: ChannelViewController) {
        reference.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var newMessages: [Message] = []
                for document in querySnapshot!.documents {
                    if let message = Message(with: document.data()) {
                        newMessages.append(message)
                    }
                }
                DispatchQueue.main.async {
                    controller.updateMessages(with: newMessages)
                }
                
            }
        }
    }
}
