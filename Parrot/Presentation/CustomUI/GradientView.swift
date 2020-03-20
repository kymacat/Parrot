//
//  GradientView.swift
//  Parrot
//
//  Created by Const. on 01.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class GradientView : UIView {
    
    var startColor: UIColor = .white {
        didSet {
            self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        }
    }
    
    var endColor: UIColor = .black {
        didSet {
            self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        }
    }
    
    var startLocation: CGFloat = 0 {
        didSet {
            self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
        }
    }
    
    var endLocation: CGFloat = 1 {
        didSet {
            self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
        }
    }
    
    var startPoint: CGPoint = .zero {
        didSet {
            self.gradientLayer.startPoint = startPoint
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            self.gradientLayer.endPoint = endPoint
        }
    }
    
    override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
    
    func configure(startColor: UIColor, endColor: UIColor, startLocation: CGFloat, endLocation: CGFloat, startPoint: CGPoint, endPoint: CGPoint) {
        self.startColor = startColor
        self.endColor = endColor
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
