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

    //func messagesViewController() -> MessagesViewController
    
    //func profileViewController() -> ProfileViewController
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
        return ChannelsVCModel(channelsService: serviceAssembly.allChannelsService, senderName: "Vlad Yandola")
    }
    
    // MARK: - PinguinViewController
    
//    func messagesViewController() -> MessagesViewController {
//        return MessagesViewController(
//    }
    
    // MARK: - profileViewController
    
//    func profileViewController() -> ProfileViewController {
//        return ProfileViewController()
//    }
}
