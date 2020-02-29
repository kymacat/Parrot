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
        nameLabel.text = model.name
        
        //Проверка на наличие сообщений
        if let message = model.message {
            let fontSize = messageLabel.font.pointSize;
            messageLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.thin)
            messageLabel.text = message
            
            if model.hasUnreadMessages {
                messageLabel.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.heavy)
            }
            
            if let time = model.date {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.init(identifier: "ru_RU")
                
                //Если последнее сообщение было отправлено сегодня, то вывожу время, в ином случае вывожу дату
                if Calendar.current.isDateInToday(time) {
                    dateFormatter.dateFormat = "HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd MMM"
                }
                
                timeLabel.text = dateFormatter.string(from: time)
                
            }
        } else {
            messageLabel.text = "No messages yet"
            let fontSize = messageLabel.font.pointSize;
            messageLabel.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: fontSize)
            timeLabel.text = ""
        }
    }
    
}
