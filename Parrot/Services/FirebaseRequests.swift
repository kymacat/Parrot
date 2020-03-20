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
                    let chanel = Channel(identifier: document.documentID, with: document.data())
                    newChannels.append(chanel)
                    print("\(document.documentID) => \(document.data())")
                    
                }
                DispatchQueue.main.async {
                    controller.updateChannels(with: newChannels)
                }
                
            }
        }
        
    }
    
    static func addChannel(reference: CollectionReference, name: String) {
        reference.addDocument(data: ["name": name, "lastMessage": ""])
    }
}
