//
//  FindOnMapButton.swift
//  OnTheMap
//
//  Created by Kevin Lu on 7/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class FindOnMapButton: UIButton {
    
    let borderedButtonCornerRadius : CGFloat = 4.0
    let buttonTitleFontSize : CGFloat = 15.0
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
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor(red: 0, green: 51/255, blue: 102/255, alpha: 1), forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: buttonTitleFontSize)
        self.layer.cornerRadius = borderedButtonCornerRadius
    }

}
