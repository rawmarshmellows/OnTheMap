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
    let spanDeltaForMapView : Double = 0.05
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK : Outlets
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var findOnTheMapButton: FindOnTheMapAndSubmitButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    /* Instance variables */
    var enterURLTextField : UITextField!
    var userCoordinates : CLLocationCoordinate2D!
    var userLocation : String!
    var mapView : MKMapView!
    var submitUserDataButton : FindOnTheMapAndSubmitButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialConfigureUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK : Initial Load UI Configurations
    func initialConfigureUI() {
        /* Setting background color */
        self.view.backgroundColor = lightGrey
        bottomView.backgroundColor = lightGrey
        
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
        let tapView = UITapGestureRecognizer(target: self, action: "keyboardHide")
        mapView.addGestureRecognizer(tapView)
        
        /* Showing bottom view */
        self.view.bringSubviewToFront(bottomView)
        bottomView.backgroundColor = transparentWhite
        
        /* Hiding old button */
        findOnTheMapButton.hidden = true
        
        /* Creating new button */
        createSubmitUserDataButton()
        
        
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = userCoordinates
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
    func createSubmitUserDataButton() {
        let buttonFrame = findOnTheMapButton.frame
        submitUserDataButton = FindOnTheMapAndSubmitButton(frame: buttonFrame)
        submitUserDataButton.setTitle("Submit", forState: UIControlState.Normal)
        submitUserDataButton.addTarget(self, action: "submitUserData", forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(submitUserDataButton)
        
    }
    // MARK: - Buttons
    
    @IBAction func goBackToPreviousViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnTheMapButton(sender: AnyObject) {
        if (enterLocationTextField.text == "") {
            showAlert("Error", message: "Please enter location", confirmButton: "OK")
        }
        else {
            userLocation = enterLocationTextField.text
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(userLocation!, completionHandler: {(placemarks, error) -> Void in
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
    
    func submitUserData() {
        if (enterURLTextField.text == "") {
            showAlert("Error", message: "Please enter a link", confirmButton: "OK")
            return
        }
        
        // Setting the userInfo values
        appDelegate.userInformation!.mediaURL = enterURLTextField.text
        appDelegate.userInformation!.mapString = userLocation
        appDelegate.userInformation!.latitude = userCoordinates.latitude
        appDelegate.userInformation!.longitude = userCoordinates.longitude
        
        ParseClient.sharedInstance().postStudentData() { (success, errorString) in
            if (success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                self.showAlert("Error", message: errorString!, confirmButton: "OK")
            }
        }
        
        
    }
    

    // MARK: Keyboard
    
    func keyboardHide() {
        // endEditing iterates through the subviews of our view and dismisses the keyboard which is a subview?
        self.view.endEditing(true)
    }
    

    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == enterLocationTextField) {
            if (textField.text == "") {
                configureTextField(enterLocationTextField, placeholder: "Enter location here")
            }
        }
        else if (textField == enterURLTextField) {
            if(textField.text == "") {
                configureTextField(enterLocationTextField, placeholder: "Enter a link to share here")
            }
        }
    }
}
