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

protocol IChannelsService {
    func fetchChannels()
    func addChannel(senderName: String, senderID: String, with name: String)
    func deleteChannel(with identifier: String)
    func getFetchResultsController() -> NSFetchedResultsController<Channel>
}

class ChannelsService : IChannelsService {
    
    // FireBase
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    let firebase: IChannelsFirebaseRequests
    
    // coreData
    let fetchedResultsController: NSFetchedResultsController<Channel>
    let dataManager: IChannelsFileManager
    var channels: [ChannelModel] = []
    var newChannels: [ChannelModel] = []
    
    
    init(firebaseRequests: IChannelsFirebaseRequests, channelsFileManager: IChannelsFileManager) {
        self.firebase = firebaseRequests
        self.dataManager = channelsFileManager
        self.fetchedResultsController = channelsFileManager.getFetchResultsController()
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
        
        dataManager.editStatusOfChannels(channels: newChannels)
        
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
