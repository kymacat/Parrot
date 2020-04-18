//
//  ServicesAssembly.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
protocol IServicesAssembly {
    var allChannelsService: IChannelsService { get }
    var messagesService: IMessagesService { get }
    var profileService: IProfileService { get }
    var imagesService: IImagesService { get }
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var allChannelsService: IChannelsService = ChannelsService(firebaseRequests: coreAssembly.channelsFirebaseRequests, channelsFileManager: coreAssembly.channelsFileManager)
    lazy var messagesService: IMessagesService = MessagesService(firebaseRequests: coreAssembly.messagesFirebaseRequests)
    lazy var profileService: IProfileService = ProfileService(dataManager: coreAssembly.profileFileManager)
    lazy var imagesService: IImagesService = ImagesService(requestSender: coreAssembly.requestSender)
}
