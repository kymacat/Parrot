//
//  MessagesService.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase

protocol IMessagesService {
    func getMessages(channelIdentifier: String, for VC: MessagesViewController)
    func sendMessage(message: MessageModel, channelIdentifier: String)
}

class MessagesService : IMessagesService {
    
    private lazy var db = Firestore.firestore()
    
    
    private let firebase: IMessagesFirebaseRequests
    
    
    
    init(firebaseRequests: IMessagesFirebaseRequests) {
        self.firebase = firebaseRequests
    }
    
    func getMessages(channelIdentifier: String, for VC: MessagesViewController) {
        let reference: CollectionReference = {
            return db.collection("channels").document(channelIdentifier).collection("messages")
        }()
        firebase.getMessages(reference: reference, for: VC)
    }
    func sendMessage(message: MessageModel, channelIdentifier: String) {
        let reference: CollectionReference = {
            return db.collection("channels").document(channelIdentifier).collection("messages")
        }()
        firebase.sendMessage(reference: reference, message: message)
    }
    
}
