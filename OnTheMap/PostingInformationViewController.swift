//
//  PostingInformationViewController.swift
//  OnTheMap
//
//  Created by Kevin Lu on 7/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostingInformationViewController: UIViewController, UITextFieldDelegate {

    // MARK : Constants
    let textFieldFontSize : CGFloat = 25.0
    let lightNavyBlue : UIColor = UIColor(red: 10/255, green: 100/255, blue: 165/255, alpha: 1)
    let lightGrey : UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    let transparentWhite : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    let enterURLTextFieldHeight : CGFloat = 100.0
    let spanDeltaForMapView : Double = 0.001
    
    // MARK : Outlets
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var findOnTheMapView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var findOnMapAndSubmitButton: FindOnMapAndSubmitButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    /* Instance variables */
    var enterURLTextField : UITextField!
    var userCoordinates : CLLocationCoordinate2D!
    var mapView : MKMapView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfigureUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardWillShowNotifications()
        self.subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardWillHideNotifications()
        self.unsubscribeFromKeyboardWillShowNotifications()
    }
    
    // MARK : Initial Load UI Configurations
    func initialConfigureUI() {
        /* Setting background color */
        self.view.backgroundColor = lightGrey
        findOnTheMapView.backgroundColor = lightGrey
        
        /* Setting textField background color */
        enterLocationTextField.backgroundColor = lightNavyBlue
        
        /* Setting textField */
        configureTextField(enterLocationTextField, placeholder: "Enter location here")
        
        
        /* Adding tapViews */
        let tapView = UITapGestureRecognizer(target: self, action: "keyboardHide")
        self.view.addGestureRecognizer(tapView)
    }
    
    
    
    func configureTextField(textField : UITextField, placeholder: String) {
        
        /* Cleaning textField */
        textField.text = ""
        
        
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Roboto-Regular", size: textFieldFontSize)!
        ]
        let myAttributedStringForPlaceHolder = NSAttributedString(string: placeholder, attributes: textAttributes)
        textField.attributedPlaceholder = myAttributedStringForPlaceHolder
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self
    }

    // MARK : After button pressed UI Configurations
    func afterLocationConfigureUI() {
        
        /* Cleaning up initial UI */
        
        /* Hiding the title labels */
        topLabel.hidden = true
        middleLabel.hidden = true
        bottomLabel.hidden = true
        
        /* Setting up the new UI */
        
        /* Changing background color */
        self.view.backgroundColor = lightNavyBlue
        
        /* Changing cancel color label */
        self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        /* Hiding old textField */
        enterLocationTextField.hidden = true
        
        /* Creating new textField */
        createEnterURLTextField()
        
        /* Creating new mapView */
        createMapViewAtLocation()
        
        /* Showing bottom view */
        self.view.bringSubviewToFront(findOnTheMapView)
        findOnTheMapView.backgroundColor = transparentWhite
        
        
        
    }
    
    func createEnterURLTextField() {
        let newFrameForTextField : CGRect = CGRectMake(self.view.frame.origin.x, cancelButton.frame.maxY, self.view.frame.width, enterURLTextFieldHeight)
        enterURLTextField = UITextField(frame: newFrameForTextField)
        configureTextField(enterURLTextField, placeholder: "Enter a link to share here")
        self.view.addSubview(enterURLTextField)
        enterURLTextField.backgroundColor = UIColor.clearColor()
        
    }

    func createMapViewAtLocation() {
        let distFromEnterURLTextFieldToBottom = self.view.frame.maxY - enterURLTextField.frame.maxY
        let frameForMapView : CGRect = CGRectMake(self.view.frame.origin.x, enterURLTextField.frame.maxY, self.view.frame.width, distFromEnterURLTextFieldToBottom)
        print(frameForMapView)
        mapView = MKMapView(frame: frameForMapView)
        self.view.addSubview(mapView)
        updateMapView()
    }
    
    func updateMapView() {
        let span = MKCoordinateSpanMake(spanDeltaForMapView, spanDeltaForMapView)
        let region = MKCoordinateRegion(center: userCoordinates, span: span)
        print(region)
        mapView.regionThatFits(region)
    }
    // MARK: - Buttons
    
    @IBAction func goBackToPreviousViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnTheMapButton(sender: AnyObject) {
        if (findOnMapAndSubmitButton.titleLabel!.text == "Find on the map") {
            findOnTheMapButton()
        }
        else if (findOnMapAndSubmitButton.titleLabel!.text == "Submit") {
            submitUserDataButton()
        }
    }
    
    func findOnTheMapButton() {
        if (enterLocationTextField.text == "") {
            showAlert("Error", message: "Please enter location", confirmButton: "OK")
        }
        else {
            let address = enterLocationTextField.text
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    self.showAlert("Error", message: "Geocoder has failed", confirmButton: "OK")
                }
                if let placemark = placemarks?.first {
                    self.userCoordinates = placemark.location!.coordinate
                    self.afterLocationConfigureUI()
                }
            })
        }

    }
    
    func submitUserDataButton() {
        // Nothing
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

    
    // MARK: - Alert
    func showAlert(title : String, message : String, confirmButton : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: confirmButton, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == enterLocationTextField) {
            textField.placeholder = "Enter location here"
        }
        else if (textField == enterURLTextField){
            textField.placeholder = "Enter a link to share here"
        }
    }
}
