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
    var lat : CLLocationDegrees!
    var long : CLLocationDegrees!
    var coordinate : CLLocationCoordinate2D!
    var firstName : String!
    var lastName : String!
    var uniqueKey : String!
    var mediaURL : String!
    
    init(studentInformation : [String : AnyObject]) {
        if (studentInformation["latitude"] == nil) {
            self.lat = nil
            self.long = nil
            self.coordinate = nil
        }
        else {
            self.lat = CLLocationDegrees(studentInformation["latitude"] as! Double)
            self.long = CLLocationDegrees(studentInformation["longitude"] as! Double)
            self.coordinate = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.long!)
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
    }
}