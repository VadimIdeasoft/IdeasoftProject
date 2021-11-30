//
//  DirectionalPanGestureRecognizer.swift
//  IdeaSoft_Project
//
//  Created by IdeaSoft on 30.11.2021.
//

import UIKit.UIGestureRecognizerSubclass

enum PanDirection {
    case vertical
    case horizontal
}

class DirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    let direction: PanDirection
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        guard state == .began else {
            return
        }
        
        let vel = velocity(in: view)
        
        switch direction {
        case .horizontal where abs(vel.y) > abs(vel.x):
            state = .cancelled
        case .vertical where abs(vel.x) > abs(vel.y):
            state = .cancelled
        default:
            break
        }
    }
}
