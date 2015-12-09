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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    
    }
    // MARK: Buttons
    @IBAction func reloadData(sender: AnyObject) {
        ParseClient.sharedInstance().getStudentData { (success, errorString) in
            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Data reloaded", message: "Data has been reloaded", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })

                
            }
                
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Data not reloaded", message: "Connection error", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
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
        return appDelegate.studentsInformation.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> InformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("informationCell", forIndexPath: indexPath) as! InformationTableViewCell
        let studentInformation = appDelegate.studentsInformation[indexPath.row]
        // Configure the cell...
        cell.studentName.text = "\(studentInformation.firstName) \(studentInformation.lastName)"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentInformation = appDelegate.studentsInformation[indexPath.row]
        let studentMediaURL = studentInformation.mediaURL!
        let app = UIApplication.sharedApplication()
        if (app.canOpenURL(NSURL(string: studentMediaURL)!)){
            app.openURL(NSURL(string: studentMediaURL)!)
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
