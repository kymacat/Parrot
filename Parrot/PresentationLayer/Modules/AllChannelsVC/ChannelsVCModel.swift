//
//  ChannelsVCModel.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import CoreData

class ChannelsVCModel {
    
    let channelsService: IAllChannelsService
    
    let reuseIdentifier = String(describing: ChannelCell.self)
    let senderName: String
    let fetchedResultsController: NSFetchedResultsController<Channel>
    
    
    init(senderName: String) {
        self.senderName = senderName
        self.channelsService = AllChannelsService()
        fetchedResultsController = channelsService.getFetchResultsController()
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
}
