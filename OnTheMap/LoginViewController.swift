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
    let loggingInLabelHeight : CGFloat = 35.0
    let loggingInlabelFontSize : CGFloat = 30.0
    let lighterOrange = UIColor(red: 1.0, green: 0.45, blue: 0, alpha: 1.0)

    
    // MARK: Outlets
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    var loggingInLabel : UILabel?
    var activityIndicatorView : UIActivityIndicatorView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialConfigureUI()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
        self.subscribeToKeyboardWillShowNotifications()
        self.subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.removeEffects()
        loggingInLabel?.hidden = true
        activityIndicatorView?.stopAnimating()
        self.unsubscribeFromKeyboardWillHideNotifications()
        self.unsubscribeFromKeyboardWillShowNotifications()
    }
    
    // MARK: Initial UI Configuration
    func initialConfigureUI() {
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
        configureSignUpLabel()
        
        /* Adding tapviews */
        let tapView = UITapGestureRecognizer(target: self, action: "keyboardHide")
        self.view.addGestureRecognizer(tapView)
        
        /* Configure the hidden labels that are shown when login button is pressed */
        createLoggingInLabel()
        configureLoggingInLabel()
        loggingInLabel!.hidden = true
        
        /* Create the activity indicator view */
        createActivityIndicatorView()
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
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func configureSignUpLabel() {
        let tapView = UITapGestureRecognizer(target: self, action: "openUdacityWebpage")
        signUpLabel.font = UIFont(name: "Roboto-Regular", size: signUpFontSize)
        signUpLabel.textColor = UIColor.whiteColor()
        signUpLabel.text = "Don't have an account? Sign Up"
        signUpLabel.userInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tapView)
    }
    
    func openUdacityWebpage() {
        UIApplication.sharedApplication().openURL(NSURL(string :"http://www.udacity.com")!)
    }
    
    //  MARK : After login UI Configuration
    func afterLoginConfigureUI () {
        /* Blur the view */
        self.view.blurView(style: UIBlurEffectStyle.Light)
        
        /* Configure the label and bring it forwards */
        configureLoggingInLabel()
        self.view.bringSubviewToFront(loggingInLabel!)
        loggingInLabel!.hidden = false
        
        /* Bring the ActivityIndicatorView fowards */
        self.view.bringSubviewToFront(activityIndicatorView!)
    }
    
    func createLoggingInLabel () {
        let labelFrame = CGRectMake(0, self.view.frame.maxY/2.5, self.view.frame.width, loggingInLabelHeight)
        loggingInLabel = UILabel(frame: labelFrame)
        self.view.addSubview(loggingInLabel!)
    }
    
    func configureLoggingInLabel() {
        loggingInLabel!.font = UIFont(name: "Roboto-Medium", size: loggingInlabelFontSize)
        loggingInLabel!.textColor = UIColor.whiteColor()
        loggingInLabel!.text = "Logging in..."
        loggingInLabel!.textAlignment = NSTextAlignment.Center
        
    }
    func createActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicatorView?.center = self.view.center
        activityIndicatorView?.color = UIColor.whiteColor()
        self.view.addSubview(activityIndicatorView!)
    }
    
    // MARK: Keyboard
    
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
    func subscribeToKeyboardWillShowNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }

    
    // MARK: Buttons
    @IBAction func loginButton(sender: AnyObject) {
        /* Updating the UI before posting user data */
        afterLoginConfigureUI()
        
        /* Start the activity indicator */
        activityIndicatorView?.startAnimating()
        /* Create request */
        UdacityClient.sharedInstance().authenticateLoginDetails(self) {(success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                self.keyboardHide()
            })
            if (success) {
                self.completeLogin()
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Error", message: errorString!, confirmButton: "OK")
                    self.loggingInLabel?.hidden = true
                    self.activityIndicatorView?.stopAnimating()
                })
            }
        }
    }
    
    func completeLogin() {
        ParseClient.sharedInstance().getStudentData { (success, errorString) in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("PostLoginTabBarController") as! UITabBarController
                    self.presentViewController(tabBarController, animated: true, completion: nil)
                })
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Error", message: errorString!, confirmButton: "OK")
                    self.loggingInLabel?.hidden = true
                    self.activityIndicatorView?.stopAnimating()
                })
                
            }
        }
        
    }
    

}


