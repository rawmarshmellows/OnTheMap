//
//  ShowAlertExtension.swift
//  OnTheMap
//
//  Created by Kevin Lu on 9/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    // MARK: - Alert
    func showAlert(title : String, message : String, confirmButton : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: confirmButton, style: UIAlertActionStyle.Default, handler: nil))
        self.view.removeEffects()
        self.presentViewController(alert, animated: true, completion: nil)
    }
}