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
    let lat : CLLocationDegrees
    let long : CLLocationDegrees
    let coordinate : CLLocationCoordinate2D
    let firstName : String!
    let lastName : String!
    let mediaURL : String!
    
    init(studentInformation : [String : AnyObject]) {
        self.lat = CLLocationDegrees(studentInformation["latitude"] as! Double)
        self.long = CLLocationDegrees(studentInformation["longitude"] as! Double)
        self.coordinate =  CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.firstName = studentInformation["firstName"] as! String!
        self.lastName = studentInformation["lastName"] as! String!
        self.mediaURL = studentInformation["mediaURL"] as! String!
    }
}