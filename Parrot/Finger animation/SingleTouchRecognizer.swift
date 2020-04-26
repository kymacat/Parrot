//
//  SingleTouchRecognizer.swift
//  Parrot
//
//  Created by Const. on 25.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class SingleTouchRecognizer: UIGestureRecognizer {
    
    var model: IFingerAnimation?
    
    
    init(target: Any?, action: Selector?, animation: IFingerAnimation?) {
        super.init(target: target, action: action)
        
        if let model = animation {
            self.model = model
            delegate = model
        }
        
        cancelsTouchesInView = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .began
            model?.startAnimation(touches, for: self)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .changed
        model?.changeCoordinatesOfAnimation(touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
    
}
