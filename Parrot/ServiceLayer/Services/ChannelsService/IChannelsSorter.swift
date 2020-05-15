//
//  IChannelsSorter.swift
//  Parrot
//
//  Created by Const. on 02.05.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

protocol IChannelsSorter {
    func sort(channels: [ChannelModel]) -> [ChannelModel]
    func groupByDate(channels: [ChannelModel]) -> [[ChannelModel]]
}
