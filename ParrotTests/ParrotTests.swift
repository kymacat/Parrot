//
//  ParrotTests.swift
//  ParrotTests
//
//  Created by Const. on 13.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import XCTest
@testable import Parrot

class ParrotTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    private var channelsSorter: IChannelsSorter!
    

    override func setUp() {
        channelsSorter = ChannelsSorter()
    }

    // MARK: - Tests
    
    func testThatChannelsSorterReturnsSortedChannels() {
        //Given
        let expectedResult = [
            ChannelModel(identifier: "1", name: "1", lastMessage: nil, activeDate: Date() - (60*29*6)),
            ChannelModel(identifier: "2", name: "2", lastMessage: nil, activeDate: Date() - (60*29*7)),
            ChannelModel(identifier: "3", name: "3", lastMessage: nil, activeDate: Date() - (60*29*8))
        ]
        let unsorted = [
            ChannelModel(identifier: "3", name: "3", lastMessage: nil, activeDate: Date() - (60*29*8)),
            ChannelModel(identifier: "1", name: "1", lastMessage: nil, activeDate: Date() - (60*29*6)),
            ChannelModel(identifier: "2", name: "2", lastMessage: nil, activeDate: Date() - (60*29*7))
        ]
        
        //When
        let result = channelsSorter.sort(channels: unsorted)
        
        XCTAssertEqual(expectedResult, result)
    }
    
    func testThatChannelsSorterReturnsGroupsByDateChannels() {
        //Given
        let expectedResult = [
            [ChannelModel(identifier: "1", name: "1", lastMessage: nil, activeDate: Date()),
             ChannelModel(identifier: "2", name: "2", lastMessage: nil, activeDate: Date())],
            [ChannelModel(identifier: "3", name: "3", lastMessage: nil, activeDate: Date() - (60*60*25))]
        ]
        let unsorted = [
            ChannelModel(identifier: "1", name: "1", lastMessage: nil, activeDate: Date()),
            ChannelModel(identifier: "3", name: "3", lastMessage: nil, activeDate: Date() - (60*60*25)),
            ChannelModel(identifier: "2", name: "2", lastMessage: nil, activeDate: Date())
        ]
        
        //When
        let result = channelsSorter.groupByDate(channels: unsorted)
        
        XCTAssertEqual(expectedResult, result)
    }

}
