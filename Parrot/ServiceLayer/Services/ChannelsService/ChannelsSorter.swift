//
//  ChannelsSorter.swift
//  Parrot
//
//  Created by Const. on 02.05.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

class ChannelsSorter: IChannelsSorter {
    func sort(channels: [ChannelModel]) -> [ChannelModel] {
        let sortClosure: (ChannelModel, ChannelModel) -> Bool = {
            guard let date1 = $0.activeDate else { return false }
            guard let date2 = $1.activeDate else { return true }
            return date1 > date2
        }
        return channels.sorted(by: sortClosure)
    }
    
    func groupByDate(channels: [ChannelModel]) -> [[ChannelModel]] {
        var activeChannels: [ChannelModel] = []
        var inactiveChannels: [ChannelModel] = []
        activeChannels = channels.filter { (channel) -> Bool in
            if let date = channel.activeDate {
                if date > Date() - (60*10) {
                    return true
                }
            }
            inactiveChannels.append(channel)
            return false
        }
        return [activeChannels, inactiveChannels]
    }
}
