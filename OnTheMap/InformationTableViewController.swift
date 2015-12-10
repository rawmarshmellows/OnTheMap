//
//  InformationTableViewController.swift
//  OnTheMap
//
//  Created by Kevin Lu on 5/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class InformationTableViewController: UITableViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let modelData = ModelData.sharedData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Buttons
    @IBAction func reloadData(sender: AnyObject) {
        ParseClient.sharedInstance().getStudentData { (success, errorString) in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Data reloaded", message: "Data has been reloaded", confirmButton: "OK")
                    print("==================================================================")
                    print(self.modelData.studentsInformation)
                })
            }
                
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Data not reloaded", message: errorString!, confirmButton: "OK")
                })
                
            }
        }
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
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelData.studentsInformation.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> InformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("informationCell", forIndexPath: indexPath) as! InformationTableViewCell
        let studentInformation = modelData.studentsInformation[indexPath.row]
        // Configure the cell...
        cell.studentName.text = "\(studentInformation.firstName) \(studentInformation.lastName)"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentInformation = modelData.studentsInformation[indexPath.row]
        let studentMediaURL = studentInformation.mediaURL!
        print(studentMediaURL)
        let app = UIApplication.sharedApplication()
        let url : NSURL?
        url = NSURL(string: studentMediaURL)
        if let url = url {
            if (app.canOpenURL(url)){
                app.openURL(url)
            }
            else {
                self.showAlert("Error", message: "Invalid URL", confirmButton: "OK")
            }
        }
        else {
            self.showAlert("Error", message: "Invalid URL", confirmButton: "OK")
        }
        
//        var updatedStudentMediaURL : String!
//        
//        
//        if (studentMediaURL.characters.count < 7) {
//            showAlert("Error", message: "Not a valid URL", confirmButton: "OK")
//        }
//        
//        else {
//            var index = studentMediaURL.startIndex.advancedBy(7)
//            
//            if (studentMediaURL.substringToIndex(index) == "http://") {
//                updatedStudentMediaURL = studentMediaURL
//            }
//            else {
//                updatedStudentMediaURL = "http://" + studentMediaURL
//            }
//            
//            index = studentMediaURL.startIndex.advancedBy(11)
//            if (studentMediaURL.substringToIndex(index) == "http://www.") {
//                // do nothing
//            }
//            else {
//                updatedStudentMediaURL = "http://www." + studentMediaURL
//            }
//            
//        }
        
        
        
    }

}
