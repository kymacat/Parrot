//
//  ConversationCell.swift
//  Parrot
//
//  Created by Const. on 28.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(with model: ConversationCellModel) {
        
    }
    
}
