//
//  FingerAnimation.swift
//  Parrot
//
//  Created by Const. on 26.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

protocol IFingerAnimation: UIGestureRecognizerDelegate {
    func startAnimation(_ touches: Set<UITouch>, for recognizer: UIGestureRecognizer)
    func changeCoordinatesOfAnimation(_ touches: Set<UITouch>)
}

class FingerAnimation: NSObject, IFingerAnimation {
    
    private var curPosition: CGPoint?
    private var recognizer: UIGestureRecognizer?
    
    private func recurseAnimation(with views: [UIView], animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.75, delay: 0, options: [.curveEaseOut], animations: animations, completion: { [weak self] _ in
            if let recognizer = self?.recognizer {
                if recognizer.state == .began || recognizer.state == .changed {
                    if let position = self?.curPosition {
                        for view in views {
                            view.center = position
                            view.alpha = 1
                        }
                        self?.recurseAnimation(with: views, animations: animations)
                    }
                    
                } else {
                    for view in views {
                        view.removeFromSuperview()
                    }
                }
            }
            
        })
    }
    
    func startAnimation(_ touches: Set<UITouch>, for recognizer: UIGestureRecognizer) {
        self.recognizer = recognizer
        if let touch = touches.first {
            curPosition = CGPoint(x: touch.location(in: touch.window).x, y: touch.location(in: touch.window).y)
            let views = [
                UIView(frame: CGRect(x: touch.location(in: touch.window).x, y: touch.location(in: touch.window).y, width: 25, height: 25)),
                UIView(frame: CGRect(x: touch.location(in: touch.window).x, y: touch.location(in: touch.window).y, width: 25, height: 25)),
                UIView(frame: CGRect(x: touch.location(in: touch.window).x, y: touch.location(in: touch.window).y, width: 25, height: 25))
            ]
            for (num, view) in views.enumerated() {
                view.backgroundColor = .black
                view.accessibilityIdentifier = "view\(num)"
                touch.window?.addSubview(view)
            }
            let animations = {
                for view in views {
                    let randomX = CGFloat(Int.random(in: -75...75))
                    let randomY = CGFloat(Int.random(in: -75...75))
                    let point = CGPoint(x: view.center.x - randomX, y: view.center.y - randomY)
                    view.center = point
                    view.alpha = 0
                }
                
            }
            
            recurseAnimation(with: views, animations: animations)
        }
    }
    
    func changeCoordinatesOfAnimation(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            curPosition = CGPoint(x: touch.location(in: touch.window).x, y: touch.location(in: touch.window).y)
        }
    }
}

// MARK: - Recognizer Delegate
extension FingerAnimation {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
