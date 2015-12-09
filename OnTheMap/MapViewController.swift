//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kevin Lu on 5/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the mapView's delegate to self
        mapView.delegate = self
        populateAnnotations()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateAnnotations() {
        let studentsInformation = appDelegate.studentsInformation
        var annotations = [MKPointAnnotation]()
        for studentInformation in studentsInformation {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = studentInformation.coordinate!
            annotation.title = "\(studentInformation.firstName) \(studentInformation.lastName)"
            annotation.subtitle = studentInformation.mediaURL!
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
    
    func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.blueColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let studentMediaURL = annotationView.annotation!.subtitle!!
        let app = UIApplication.sharedApplication()
        if (app.canOpenURL(NSURL(string: studentMediaURL)!)){
            app.openURL(NSURL(string: studentMediaURL)!)
        }
        else {
            self.showAlert("Error", message: "Invalid URL", confirmButton: "OK")
        }
//
//
//        var updatedStudentMediaURL : String!
//        let app = UIApplication.sharedApplication()
//        
//        if control == annotationView.rightCalloutAccessoryView {
//            if (studentMediaURL.characters.count < 7) {
//                showAlert("Error", message: "Not a valid URL", confirmButton: "OK")
//            }
//                
//            else {
//                var index = studentMediaURL.startIndex.advancedBy(7)
//                
//                if (studentMediaURL.substringToIndex(index) == "http://") {
//                    updatedStudentMediaURL = studentMediaURL
//                }
//                else {
//                    updatedStudentMediaURL = "http://" + studentMediaURL
//                }
//                
//                index = studentMediaURL.startIndex.advancedBy(11)
//                if (studentMediaURL.substringToIndex(index) == "http://www.") {
//                    // do nothing
//                }
//                else {
//                    updatedStudentMediaURL = "http://www." + studentMediaURL
//                }
//                app.openURL(NSURL(string: updatedStudentMediaURL)!)
//            }
//        }
    }

    func loadData() {
        ParseClient.sharedInstance().getStudentData { (success, errorString) in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Data loaded", message: "Data has been loaded", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                })
                
            }
                
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Data not loaded", message: "Connection error", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
            }
        }
        removeAnnotations()
        populateAnnotations()
    }
    // MARK : Buttons
    @IBAction func reloadDataButton(sender: AnyObject) {
        loadData()
    }
    
    @IBAction func postDataButton(sender: AnyObject) {
        let postInfoVC = self.storyboard!.instantiateViewControllerWithIdentifier("PostingInformationViewController") as! PostingInformationViewController
        self.presentViewController(postInfoVC, animated: true, completion: nil)

    }
   
    @IBAction func logoutButton(sender: AnyObject) {
        UdacityClient.sharedInstance().logoutOfSession() { (success, errorString) in
            if (success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                self.showAlert("Error", message: errorString!, confirmButton: "OK")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
