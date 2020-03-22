//
//  HeaderLabel.swift
//  Parrot
//
//  Created by Const. on 22.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class HeaderLabel : UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        textColor = .white
        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalIntrinsicSize = super.intrinsicContentSize
        let height = originalIntrinsicSize.height + 12
        layer.cornerRadius = height/2
        clipsToBounds = true
        return CGSize(width: originalIntrinsicSize.width + 20, height: height)
    }
}
