//
//  CoreAssembly.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var firebaseRequests: IFirebaseRequests { get }
    var profileFileManager: IProfileFileManager { get }
    var channelsFileManager: IChannelsFileManager { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var firebaseRequests: IFirebaseRequests = Requests()
    lazy var profileFileManager: IProfileFileManager = ProfileFileManager()
    lazy var channelsFileManager: IChannelsFileManager = ChannelsFileManager()
}
