//
//  CustomButton.swift
//  Parrot
//
//  Created by Const. on 21.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit


class CustomButton : UIButton {
    var color: UIColor = .clear
    let touchDownAlpha: CGFloat = 0.3

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let backgroundColor = backgroundColor {
            color = backgroundColor
        }
        
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        layer.backgroundColor = color.cgColor
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    
    var timer: Timer?

    func stopTimer() {
        timer?.invalidate()
    }

    let timerStep: TimeInterval = 0.01
    let animateTime: TimeInterval = 0.4
    
    lazy var alphaStep: CGFloat = {
        return (1 - touchDownAlpha) / CGFloat(animateTime / timerStep)
    }()
    
    func touchDown() {
           stopTimer()
           layer.backgroundColor = color.withAlphaComponent(touchDownAlpha).cgColor
       }

    func touchUp() {
        timer = Timer.scheduledTimer(timeInterval: timerStep,
                                     target: self,
                                     selector: #selector(animation),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func animation() {
        guard let backgroundAlpha = layer.backgroundColor?.alpha else {
            stopTimer()

            return
        }

        let newAlpha = backgroundAlpha + alphaStep

        if newAlpha < 1 {
            layer.backgroundColor = color.withAlphaComponent(newAlpha).cgColor
        } else {
            layer.backgroundColor = color.cgColor

            stopTimer()
        }
    }
}
