//
//  ChannelsVCModel.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import CoreData

protocol IChannelsVCModel {
    func fetchChannels()
    func addChannel(with name: String)
    func deleteChannel(with identifier: String)
    func getFetchedResultsController() -> NSFetchedResultsController<Channel>
}

class ChannelsVCModel : IChannelsVCModel {
    
    let channelsService: IChannelsService
    let senderName: String
    let senderID: String
    
    
    init(channelsService: IChannelsService, senderName: String, senderID: String) {
        self.channelsService = channelsService
        self.senderName = senderName
        self.senderID = senderID
    }
    
    func fetchChannels() {
        channelsService.fetchChannels()
    }
    
    
    func addChannel(with name: String) {
        channelsService.addChannel(senderName: senderName, senderID: senderID, with: name)
    }
    
    
    func deleteChannel(with identifier: String) {
        channelsService.deleteChannel(with: identifier)
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController<Channel> {
        return channelsService.getFetchResultsController()
    }
}
