//
//  PostingInformationViewController.swift
//  OnTheMap
//
//  Created by Kevin Lu on 7/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import UIKit

class PostingInformationViewController: UIViewController {

    /* Constants */
    let textFieldFontSize : CGFloat = 15.0
    let lightNavyBlue : UIColor = UIColor(red: 0, green: 128/255, blue: 255/255, alpha: 1)
    let lightGrey : UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    /* Outlets */
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var textField: UITextField!
 
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        /* Setting background color */
        self.view.backgroundColor = lightGrey
        
        /* Setting textField background color */
        self.subView.backgroundColor = lightNavyBlue
        
        /* Setting textField */
        configureTextField(textField)
        
        /* Adding tapViews */
        let tapView = UITapGestureRecognizer(target: self, action: "keyboardHide")
        self.view.addGestureRecognizer(tapView)
        self.subView.addGestureRecognizer(tapView)
    }
    
    func configureTextField(textField : UITextField) {
        let textAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Roboto-Regular", size: textFieldFontSize)!
        ]
        textField.defaultTextAttributes = textAttributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Buttons
    
    @IBAction func goBackToPreviousViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Keyboard
    func keyboardHide() {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
