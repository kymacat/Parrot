//
//  PresentationAssembly.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

import UIKit

protocol IPresentationAssembly {
    func channelsViewController() -> ChannelsViewController

    func messagesViewController(channel: ChannelModel) -> MessagesViewController
    
    func profileViewController() -> ProfileViewController
    
    func imagesViewController(unwindController: ProfileViewController) -> ImagesViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ChannelsViewCintroller
    
    func channelsViewController() -> ChannelsViewController {
        let model = channelsVCModel()
        let viewController = ChannelsViewController(model: model, presentationAssembly: self)
        return viewController
    }
    
    private func channelsVCModel() -> IChannelsVCModel {
        return ChannelsVCModel(channelsService: serviceAssembly.allChannelsService, senderName: "Vlad Yandola", senderID: "123654")
    }
    
    // MARK: - PinguinViewController
    
    func messagesViewController(channel: ChannelModel) -> MessagesViewController {
        let model = messagesVCModel(channel: channel)
        let viewController = MessagesViewController(model: model, presentationAssembly: self, name: channel.name)
        return viewController
    }
    
    private func messagesVCModel(channel: ChannelModel) -> IMessagesVCModel {
        return MessagesVCModel(messagesService: serviceAssembly.messagesService, channel: channel, senderName: "Vlad Yandola", senderID: "123654")
    }
    
    // MARK: - profileViewController
    
    func profileViewController() -> ProfileViewController {
        let model = profileVCModel()
        let viewController = ProfileViewController(model: model, presentationAssembly: self)
        return viewController
    }
    
    private func profileVCModel() -> IProfileVCModel {
        return ProfileVCModel(profileService: serviceAssembly.profileService)
    }
    
    // MARK: - imagesViewController
    
    func imagesViewController(unwindController: ProfileViewController) -> ImagesViewController {
        var model = imagesVCModel()
        let viewController = ImagesViewController(model: model, presentationAssembly: self, unwindController: unwindController)
        model.delegate = viewController
        return viewController
    }
    
    private func imagesVCModel() -> IImagesVCModel {
        return ImagesVCModel(imagesService: serviceAssembly.imagesService)
    }
}
