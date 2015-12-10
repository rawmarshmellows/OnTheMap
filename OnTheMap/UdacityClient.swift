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
    let modelData = ModelData.sharedData()
    
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
//        let HTTPBody = createHTTPBody(hostViewController)
//        request.HTTPBody = HTTPBody.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = "{\"udacity\": {\"username\": \"kevinyihchyunlu@gmail.com\", \"password\": \"V+.i2##=Ln\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        

        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            print("In task")
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
                    self.modelData.userInformation = StudentInformation(studentInformation: ["uniqueKey" : uniqueKey])
                    // get user data
                    self.getUserData() { (success, errorString) in
                        if(success) {
                            completionHandler(success: success, errorString: nil)
                        }
                        else {
                            completionHandler(success: success, errorString: errorString)
                            return
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
    
    func createHTTPBody(hostViewController: LoginViewController) -> String {
        var HTTPBody = "{\"udacity\":"
        HTTPBody +=    "{\"username\": \"" + hostViewController.emailTextField.text!
        HTTPBody +=    "\", \"password\": \"" + hostViewController.passwordTextField.text!
        HTTPBody +=    "\"}}"
        return HTTPBody
    }
    
    func getUserData(completionHandler : (success : Bool, errorString : String?) -> Void) {
        let uniqueKey = modelData.userInformation!.uniqueKey
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + uniqueKey)!)
        print("https://www.udacity.com/api/users/" + uniqueKey)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Checking for errors
            guard (error == nil) else {
                completionHandler(success: false, errorString: "There was an networking error")
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "There was an error in the request for data")
                return
            }
            
            /* subset response data! */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
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
                    self.modelData.userInformation!.firstName = firstName
                    self.modelData.userInformation!.lastName = lastName
                    print(self.modelData.userInformation!)
                    completionHandler(success: true, errorString: nil)
                }
            }
        }
        task.resume()
    }
    func logoutOfSession(completionHandler : (success : Bool, errorString : String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: "Logout out failed")
                return
            }
            else {
                completionHandler(success: true, errorString: nil)
            }

        }
        task.resume()
    }
}


