//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Kevin Lu on 5/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient : NSObject {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var sessionID : String?
    
    override init() {
        super.init()
    }
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func authenticateLoginDetails(hostViewController : LoginViewController, completionHandler : (success: Bool, errorString: String?) -> Void) {

        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        var HTTPBody = "{\"udacity\": {\"username\":"
//        HTTPBody += "\""
//        HTTPBody += hostViewController.emailTextField.text!
//        HTTPBody += "\","
//        HTTPBody += "\"password\":"
//        HTTPBody += "\""
//        HTTPBody += hostViewController.passwordTextField.text!
//        HTTPBody += "\"}}"
//        request.HTTPBody = HTTPBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = "{\"udacity\": {\"username\": \"kevinyihchyunlu@gmail.com\", \"password\": \"V+.i2##=Ln\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // Checking for errors
            guard (error == nil) else {
                completionHandler(success: false, errorString: "There was an networking error")
                return
            }
//            print("Error is: " + String(error))

            guard let data = data else {
                completionHandler(success: false, errorString: "There was an error in the request for data")
                return
            }
//            print("Data is: " + String(data))
            
            // Trying to parse the data as JSON
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

            let parsedResult : AnyObject?
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! [String:AnyObject]
            }
            catch {
                completionHandler(success: false, errorString: "There was an error in the conversion for data")
                return
            }
            if let parsedResult = parsedResult {
                if (parsedResult.objectForKey("error") == nil) {
                    self.sessionID = String(parsedResult["session"]!!["id"])
                    let uniqueKey = parsedResult["account"]!!["key"]! as! String
                    print(uniqueKey)
                    self.appDelegate.userInformation = StudentInformation(studentInformation: ["uniqueKey" : uniqueKey])
                    print(self.appDelegate.userInformation!)
                    // get user data
                    self.getUserData() { (success, errorString) in
                        if(success) {
                            completionHandler(success: success, errorString: nil)
                        }
                        else {
                            completionHandler(success: success, errorString: errorString)
                        }
                        
                    }
                }
                else {
                    completionHandler(success: false, errorString: "Please check email and password")
                    return
                }
            }
            
        }
        task.resume()
    }
    
    func getUserData(completionHandler : (success : Bool, errorString : String?) -> Void) {
        let uniqueKey = appDelegate.userInformation!.uniqueKey
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + uniqueKey)!)
        print("https://www.udacity.com/api/users/" + uniqueKey)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Can't retrieve user data")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let parsedResult: AnyObject?
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            }
            catch {
                completionHandler(success: false, errorString: "There was an error in the conversion for data")
                return
            }
            
            if let parsedResult = parsedResult {
                if (parsedResult.objectForKey("error") == nil) {
                    let firstName = parsedResult["user"]!!["first_name"] as! String
                    let lastName = parsedResult["user"]!!["last_name"] as! String
                    self.appDelegate.userInformation!.firstName = firstName
                    self.appDelegate.userInformation!.lastName = lastName
                    print(self.appDelegate.userInformation!)
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
        task.resume()
    }
}


