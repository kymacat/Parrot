//
//  AllChannelsService.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol IAllChannelsService {
    func fetchChannels()
    func addChannel(senderName: String, senderID: String, with name: String)
    func deleteChannel(with identifier: String)
    func getFetchResultsController() -> NSFetchedResultsController<Channel>
}

class AllChannelsService : IAllChannelsService {
    
    // FireBase
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    let firebase: FirebaseRequests
    
    // coreData
    let fetchedResultsController: NSFetchedResultsController<Channel>
    let dataManager = CoreDataFileManager()
    var channels: [ChannelModel] = []
    var newChannels: [ChannelModel] = []
    
    
    init(firebaseRequests: FirebaseRequests) {
        self.firebase = firebaseRequests
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        let sortDescriptor = NSSortDescriptor(key: "activeDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController<Channel>(fetchRequest: fetchRequest, managedObjectContext: dataManager.managedObjectContext, sectionNameKeyPath: "isActive", cacheName: nil)
    }
    
    // MARK: - FetchChannels
    
    func fetchChannels() {
        if let channels = fetchedResultsController.fetchedObjects {
            for channel in channels {
                let newChannel = ChannelModel(identifier: channel.identifier, name: channel.name, lastMessage: channel.lastMessage, activeDate: channel.activeDate, isActive: channel.isActive)
                self.channels.append(newChannel)
            }
        }
        reference.addSnapshotListener {[weak self] (querySnapshot, err) in
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
                    self?.updateChannels(with: newChannels)
                }
            }
        }
    }
    
    func updateChannels(with newChannels: [ChannelModel]) {
        var channelsForAdd = [ChannelModel]()
        for newChannel in newChannels {
            var isHere = false
            for oldChannel in channels {
                if newChannel.identifier == oldChannel.identifier {
                    isHere = true
                    break;
                }
            }
            if !isHere {
                channelsForAdd.append(newChannel)
            }
        }
        dataManager.appendChannels(channels: channelsForAdd)
        
        var channelsToDelete = [ChannelModel]()
        for oldChannel in channels {
            var isHere = false
            for newChannel in newChannels {
                if oldChannel.identifier == newChannel.identifier {
                    isHere = true
                    break;
                }
            }
            if !isHere {
                channelsToDelete.append(oldChannel)
                
            }
        }
        dataManager.deleteChannels(channels: channelsToDelete)
        
        var channelsToUpdate = [ChannelModel]()
        for channel in channels {
            if let date = channel.activeDate {
                if (date < Date() - (60*10)) && channel.isActive {
                    channelsToUpdate.append(channel)
                }
            }
        }
        dataManager.editStatusOfChannels(channels: channelsToUpdate)
        
        channels = newChannels
        
    }
    
    // MARK: - AddChannel
    
    func addChannel(senderName: String, senderID: String, with name: String) {
        firebase.addChannel(reference: reference, name: name, senderName: senderName, senderID: senderID)
    }
    
    // MARK: - DeleteChannel
    
    func deleteChannel(with identifier: String) {
        firebase.deleteChannel(reference: reference, with: identifier)
    }
    
    func getFetchResultsController() -> NSFetchedResultsController<Channel> {
        return fetchedResultsController
    }
}
