//
//  DelegationClient.swift
//  OnTheMap
//
//  Created by Kevin Lu on 6/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

/* NOT USED AS MAKES IT OVER COMPLICATED */

/*
import Foundation

class DelegationClient : NSObject {
    let udacityClient : UdacityClient
    let parseClient : ParseClient
    class func sharedInstance() -> DelegationClient {
        struct Singleton {
            static var sharedInstance = DelegationClient()
        }
        return Singleton.sharedInstance
    }
    
    override init() {
        self.udacityClient = UdacityClient.sharedInstance()
        self.parseClient = ParseClient.sharedInstance()
    }
    
    func authenticateLoginAndRetrieveData(hostViewController : LoginViewController, completionHandler : (success: Bool, errorString: String?) -> Void) {
        self.udacityClient.authenticateLoginDetails(hostViewController) { (success, errorString) in
            
            // checking if login in success
            if (success) {
               
                // checking if data is retrievable
                self.parseClient.getStudentData() { (success, errorString) in
                    if (success) {
                        // put data into AppDelegate
                        completionHandler(success: success, errorString: errorString)
                    }
                    else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            }
            else {
                completionHandler(success: success, errorString: errorString)
                print(errorString)
            }
            
        }
    }
    
}
*/