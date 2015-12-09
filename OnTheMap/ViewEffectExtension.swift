//
//  FadeExtension.swift
//  OnTheMap
//
//  Created by Kevin Lu on 9/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func fadeIn(duration duration : NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }
    func fadeOut(duration duration : NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
    func blurView(duration duration : NSTimeInterval = 1.0, style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        
    }
    func removeEffects() {
        for subview in self.subviews {
            if (subview is UIVisualEffectView) {
                subview.removeFromSuperview()
            }
        }
    }
}