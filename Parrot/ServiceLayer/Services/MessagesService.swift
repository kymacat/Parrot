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
    func groupMessages(newMessages: [MessageModel]) -> [[MessageModel]]
}

class MessagesService : IMessagesService {
    
    private lazy var db = Firestore.firestore()
    
    
    private let firebase: IMessagesFirebaseRequests
    
    private var messages: [MessageModel] = []
    
    
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
    
    func groupMessages(newMessages: [MessageModel]) -> [[MessageModel]] {
        messages = newMessages.sorted(by: { (mes1, mes2) -> Bool in
            if mes1.created < mes2.created {
                return true
            }
            return false
        })
        return groupMessagesByDate()
    }
    
    private func groupMessagesByDate() -> [[MessageModel]] {
        let groupedMessages = Dictionary(grouping: messages) { element -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: element.created)
        }
        
        var newGroupMessages: [[MessageModel]] = []
        groupedMessages.keys.forEach { key in
            if let values = groupedMessages[key] {
                newGroupMessages.append(values)
            }
        }
        return newGroupMessages.sorted { (values1, values2) -> Bool in
            if let first1 = values1.first, let first2 = values2.first {
                if first1.created < first2.created {
                    return true
                }
            }
            return false
        }
    }
    
}
