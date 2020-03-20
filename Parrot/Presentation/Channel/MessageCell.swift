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
        
        //AutoLayout
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: (self.bounds.width/4)*3)
        ])
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        bubleBackroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bubleBackroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubleBackroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubleBackroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubleBackroundView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 32)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        if model.isIncoming {
            bubleBackroundView.backgroundColor = .darkGray
            messageLabel.textColor = .white
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        } else {
            bubleBackroundView.backgroundColor = .systemYellow
            messageLabel.textColor = .black
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        }
        
    }
    
}
