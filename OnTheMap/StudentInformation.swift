//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Kevin Lu on 7/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    var coordinate : CLLocationCoordinate2D!
    var firstName : String!
    var lastName : String!
    var uniqueKey : String!
    var mediaURL : String!
    var mapString : String!
    
    
    init(studentInformation : [String : AnyObject]?) {
        if (studentInformation == nil) {
            self.latitude = nil
            self.longitude = nil
            self.coordinate = nil
            self.firstName = nil
            self.lastName = nil
            self.uniqueKey = nil
            self.mediaURL = nil
            self.mapString = nil
        }
        else {
            if let studentInformation = studentInformation {
                if (studentInformation["latitude"] == nil) {
                    self.latitude = nil
                    self.longitude = nil
                    self.coordinate = nil
                }
                else {
                    self.latitude = CLLocationDegrees(studentInformation["latitude"] as! Double)
                    self.longitude = CLLocationDegrees(studentInformation["longitude"] as! Double)
                    self.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                }
                
                if (studentInformation["firstName"] == nil) {
                    self.firstName = nil
                }
                else {
                    self.firstName = (studentInformation["firstName"] as! String)
                }
                
                if (studentInformation["lastName"] == nil) {
                    self.lastName = nil
                }
                else {
                    self.lastName = (studentInformation["lastName"] as! String)
                }
                if (studentInformation["uniqueKey"] == nil) {
                    self.uniqueKey = nil
                }
                else {
                    self.uniqueKey = (studentInformation["uniqueKey"] as! String)
                }
                if (studentInformation["mediaURL"] == nil) {
                    self.mediaURL = nil
                }
                else {
                    self.mediaURL = (studentInformation["mediaURL"] as! String)
                }
                if (studentInformation["mapString"] == nil) {
                    self.mapString = nil
                }
                else {
                    self.mapString = (studentInformation["mapString"] as! String)
                }

            }
            
        }
    }

    
}