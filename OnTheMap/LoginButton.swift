//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Kevin Lu on 3/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    // MARK: Constants
    let borderedButtonCornerRadius : CGFloat = 4.0
    let lighterOrange = UIColor(red: 1.0, green: 0.45, blue: 0, alpha: 1.0)
    let darkerOrange = UIColor(red: 1.0, green: 0.35, blue: 0, alpha: 1.0)
    let loginLabelFontSize : CGFloat = 15.0
    
    // MARK: Properties
    var backingColor : UIColor? = nil
    var highlightedBackingColor : UIColor? = nil
    
    // MARK: Initialization
    required init(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)!
        self.themeBorderedButton()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeBorderedButton()
    }
    
    func themeBorderedButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = borderedButtonCornerRadius
        self.highlightedBackingColor = darkerOrange
        self.backingColor = lighterOrange
        self.backgroundColor = lighterOrange
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: loginLabelFontSize)
    }
    
    // MARK: Setters
    @nonobjc
    func setBackingColor(backingColor : UIColor) {
        self.backingColor = backingColor
        self.backgroundColor = backingColor
    }
    @nonobjc
    func setHighlightedBackingColor(highlightedBackingColor : UIColor) {
        self.highlightedBackingColor = highlightedBackingColor
    }
    
    // MARK: Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        self.backgroundColor = highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        self.backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        self.backgroundColor = backingColor
    }
}
