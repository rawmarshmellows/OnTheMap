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
    
    init(lat : CLLocationDegrees, long : CLLocationDegrees, coordinate : CLLocationCoordinate2D, firstName : String!, lastName : String!, mediaURL : String!) {
        self.lat = lat
        self.long = long
        self.coordinate = coordinate
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
    }
}