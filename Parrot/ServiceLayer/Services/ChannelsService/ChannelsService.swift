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
    
    var channelsSorter: IChannelsSorter
    
    // FireBase
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    let firebase: IChannelsFirebaseRequests
    
    // coreData
    let fetchedResultsController: NSFetchedResultsController<Channel>
    let dataManager: IChannelsFileManager
    var channels: [ChannelModel] = []
    
    
    init(firebaseRequests: IChannelsFirebaseRequests, channelsFileManager: IChannelsFileManager) {
        self.channelsSorter = ChannelsSorter()
        self.firebase = firebaseRequests
        self.dataManager = channelsFileManager
        self.fetchedResultsController = channelsFileManager.getFetchResultsController()
    }
    
    // MARK: - FetchChannels
    
    func fetchChannels() {
        if let channels = fetchedResultsController.fetchedObjects {
            for channel in channels {
                let newChannel = ChannelModel(identifier: channel.identifier, name: channel.name, lastMessage: channel.lastMessage, activeDate: channel.activeDate)
                self.channels.append(newChannel)
            }
        }
        firebase.getChannels(reference: reference, completionHandler: updateChannels(with:))
    }
    
    private func updateChannels(with newChannels: [ChannelModel]) {
        let sortedChannels = channelsSorter.sort(channels: newChannels)
        
        var channelsForAdd = [ChannelModel]()
        for newChannel in sortedChannels {
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
            for newChannel in sortedChannels {
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
        
        dataManager.editStatusOfChannels(channels: sortedChannels)
        
        channels = sortedChannels
        
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
