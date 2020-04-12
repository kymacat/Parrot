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
    
    let channelsService: IAllChannelsService
    let senderName: String
    
    
    
    init(channelsService: IAllChannelsService, senderName: String) {
        self.channelsService = channelsService
        self.senderName = senderName
    }
    
    func fetchChannels() {
        channelsService.fetchChannels()
    }
    
    
    func addChannel(with name: String) {
        channelsService.addChannel(senderName: senderName, senderID: "123654", with: name)
    }
    
    
    func deleteChannel(with identifier: String) {
        channelsService.deleteChannel(with: identifier)
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController<Channel> {
        return channelsService.getFetchResultsController()
    }
}
