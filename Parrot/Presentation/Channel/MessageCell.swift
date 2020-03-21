//
//  MessageCell.swift
//  Parrot
//
//  Created by Const. on 01.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    let messageLabel = UILabel()
    let bubleBackroundView = UIView()
    let timeLabel = UILabel()
    let senderLabel = UILabel()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear


        bubleBackroundView.layer.cornerRadius = 16
        addSubview(bubleBackroundView)
        
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
        
        timeLabel.numberOfLines = 1
        timeLabel.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 14)
        timeLabel.textAlignment = .right
        addSubview(timeLabel)
        
        senderLabel.numberOfLines = 1
        senderLabel.textAlignment = .left
        senderLabel.font = timeLabel.font
        addSubview(senderLabel)
        
        //AutoLayout
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: (self.bounds.width/4)*3)
        ])
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            senderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            senderLabel.leadingAnchor.constraint(equalTo: bubleBackroundView.leadingAnchor, constant: 10),
            senderLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor)
            
        ])
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            timeLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: bubleBackroundView.trailingAnchor, constant: -8)
            
        ])
        
        bubleBackroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bubleBackroundView.topAnchor.constraint(equalTo: senderLabel.topAnchor, constant: -6),
            bubleBackroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubleBackroundView.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 6),
            bubleBackroundView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 32)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        senderLabel.text = model.senderName
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: model.date)
        
        
        if model.isIncoming {
            senderLabel.textColor = .systemYellow
            timeLabel.textColor = .lightGray
            bubleBackroundView.backgroundColor = .darkGray
            messageLabel.textColor = .white
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        } else {
            timeLabel.textColor = .darkGray
            senderLabel.text = ""
            bubleBackroundView.backgroundColor = .systemYellow
            messageLabel.textColor = .black
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        }
        
    }
    
}
