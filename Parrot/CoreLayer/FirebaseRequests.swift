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
    
    func addChannel(reference: CollectionReference, name: String, senderName: String, senderID: String)
    
    func deleteChannel(reference: CollectionReference, with identifier: String)
    
    func getMessages(reference: CollectionReference, for controller: MessagesViewController)
    
    func sendMessage(reference: CollectionReference, message: MessageModel)
    
}

class Requests: FirebaseRequests {
    
    func addChannel(reference: CollectionReference, name: String, senderName: String, senderID: String) {
        let document = reference.addDocument(data: ["name": name, "lastMessage": ""])
        let message = MessageModel(content: "\(senderName) создал новый канал", created: Date(), senderID: senderID, senderName: senderName)
        
        document.collection("messages").addDocument(data: message.toDict)
        
    }
    
    func deleteChannel(reference: CollectionReference, with identifier: String) {
        reference.document(identifier).delete()
    }
    
    func getMessages(reference: CollectionReference, for controller: MessagesViewController) {
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
