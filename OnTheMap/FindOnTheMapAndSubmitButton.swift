//
//  FindOnMapButton.swift
//  OnTheMap
//
//  Created by Kevin Lu on 7/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class FindOnTheMapAndSubmitButton: UIButton {
    
    let borderedButtonCornerRadius : CGFloat = 6.0
    let buttonTitleFontSize : CGFloat = 15.0
 let lightNavyBlue : UIColor = UIColor(red: 10/255, green: 100/255, blue: 165/255, alpha: 1)
    
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
        self.setTitleColor(lightNavyBlue, forState: .Normal)
        self.titleLabel?.font = UIFont(name: "Roboto-Regular", size: buttonTitleFontSize)
        self.layer.cornerRadius = borderedButtonCornerRadius
    }

}
