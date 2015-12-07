//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Kevin Lu on 6/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class ParseClient : NSObject {
    
    var session : NSURLSession?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    override init() {
        self.session = NSURLSession.sharedSession()
        super.init()
    }
    
    func getStudentData(completionHandler : (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        session = NSURLSession.sharedSession()
        let task = session!.dataTaskWithRequest(request) { data, response, error in
            // Checking for errors
            guard (error == nil) else {
                completionHandler(success: false, errorString: "There was an networking error")
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "There was an error in the request for data")
                return
            }
            
            // Trying to parse the data as JSON
            let parsedResult : AnyObject?
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String : AnyObject]
            }
            catch {
                completionHandler(success: false, errorString: "There was an error in the conversion for data`")
                return
            }
//            print(parsedResult)
            let parsedResultAsArray : [[String : AnyObject]]
            if let parsedResult = parsedResult {
                parsedResultAsArray = parsedResult["results"] as! [[String: AnyObject]]
//                print("Printing parsedResultAsArray: " + String(parsedResultAsArray))
                self.addStudentInformation(parsedResultAsArray)
                completionHandler(success: true, errorString: nil)
//                print(self.appDelegate.locations)
            }
            
        }
        task.resume()
        print("done loading data")
    }
    func addStudentInformation(studentsInformation : [[String: AnyObject]]) {
        for studentInformation in studentsInformation {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(studentInformation["latitude"] as! Double)
            let long = CLLocationDegrees(studentInformation["longitude"] as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = studentInformation["firstName"] as! String!
            let lastName = studentInformation["lastName"] as! String!
            let mediaURL = studentInformation["mediaURL"] as! String!
            
            // Appending the student information to the list
            appDelegate.studentsInformation.append(StudentInformation(lat: lat, long: long, coordinate: coordinate, firstName: firstName, lastName: lastName, mediaURL: mediaURL))
        }
    }
}