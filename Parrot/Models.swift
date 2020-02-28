//
//  Models.swift
//  Parrot
//
//  Created by Const. on 28.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation


protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
