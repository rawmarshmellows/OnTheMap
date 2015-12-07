//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kevin Lu on 2/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let textFieldFontSize : CGFloat = 15.0
    let debugLabelFontSize : CGFloat = 15.0
    let signUpFontSize : CGFloat = 15.0
    let loginLabelFontSize : CGFloat = 24.0
    
    // MARK: Outlets
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLogin: LoginButton!
    @IBOutlet weak var signUpLabel: UILabel!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardWillShowNotifications()
        self.subscribeToKeyboardWillHideNotifications()
    }

    func configureUI() {
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1).CGColor
        let colorBottom = UIColor(red: 1, green: 0.5, blue: 0, alpha: 1).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure header text label */
        loginLabel.font = UIFont(name: "Roboto-Regular", size: loginLabelFontSize)
        loginLabel.textColor = UIColor.whiteColor()
        
        /* Configure text fields */
        configureTextField(emailTextField, placeholder: "Email")
        configureTextField(passwordTextField, placeholder: "Password")
        
        /* Configure signup label */
        signUpLabel.font = UIFont(name: "Roboto-Regular", size: signUpFontSize)
        signUpLabel.textColor = UIColor.whiteColor()
        signUpLabel.text = "Don't have an account? Sign Up"
        
        /* Configure Facebook login*/
        facebookLogin.setBackingColor(UIColor(red: 58/255, green: 89/255, blue: 152/255, alpha: 1.0))
        facebookLogin.setHighlightedBackingColor(UIColor(red: 58/255, green: 89/255, blue: 152/255, alpha: 1.0))
        
        /* Adding tapviews */
        let tapView = UITapGestureRecognizer(target: self, action: "keyboardHide")
        self.view.addGestureRecognizer(tapView)
    }
    
  
    func configureTextField(textField : UITextField, placeholder: String) {
        
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Roboto-Regular", size: textFieldFontSize)!
        ]

//        let myAttributedStringForText = NSAttributedString(string: placeholder, attributes: textAttributes)
//        textField.attributedText = myAttributedStringForText
        
        let myAttributedStringForPlaceHolder = NSAttributedString(string: placeholder, attributes: textAttributes)
        textField.attributedPlaceholder = myAttributedStringForPlaceHolder
        textField.defaultTextAttributes = textAttributes
        textField.borderStyle = UITextBorderStyle.None
        textField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        // Setting the indent
        let indentView = UIView(frame: CGRectMake(0,0,10,10))
        textField.leftView = indentView
        textField.leftViewMode = UITextFieldViewMode.Always
        // Can only set height if autolayout is disabled!
//        textField.frame.size.height = 50
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            // Creating needed controllers
            let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("PostLoginTabBarController") as! UITabBarController
            //            let tableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InformationTableViewController") as! InformationTableViewController
            //            let tableViewNavController = UINavigationController(rootViewController: tableViewController)
            //            let mapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            //            let mapViewNavController = UINavigationController(rootViewController: mapViewController)
            //            tabBarController.setViewControllers([tableViewNavController, mapViewNavController], animated: true)
            self.presentViewController(tabBarController, animated: true, completion: nil)
        })
    }

    
    func subscribeToKeyboardWillShowNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardHideShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }

    // MARK: Keyboard movement
    
    func keyboardHide() {
        // endEditing iterates through the subviews of our view and dismisses the keyboard which is a subview?
        self.view.endEditing(true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let screenOrigin = self.view.frame.origin.y
        if (self.view.frame.origin.y == 0) {
            // don't move the down view if it is already at the origin
        }
        else {
            self.view.frame.origin.y += -(screenOrigin)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (self.view.frame.origin.y == -getKeyboardHeight(notification)) {
            // don't move the view up if it is already up
        }
        else if (self.view.frame.origin.y == 0) {
            self.view.frame.origin.y -= getKeyboardHeight(notification)

        }

    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    // MARK: Buttons
    @IBAction func loginButton(sender: AnyObject) {
       UdacityClient.sharedInstance().authenticateLoginDetails(self) {(success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.keyboardHide()
            })
            if (success) {
                self.completeLogin()
            }
            else if (errorString == "There was an networking error") {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
            }
            else if (errorString == "There was an error in the request for data") {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                })
            }
            else if (errorString == "There was an error in the conversion for data") {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                })
            }
            else if (errorString == "Please check email and password") {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                })
            }
        
        }
    }
}
