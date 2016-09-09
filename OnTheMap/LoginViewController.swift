//
//  ViewController.swift
//  OnTheMap
//
//  Created by Jennifer Person on 7/31/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: RounderButton!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var udacityImageView: UIImageView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure keyboard to disappear when tapping outside of it
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
        
        // Hide activity indicator
        self.activityIndicator.hidden = true
        self.activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }

    @IBAction func LoginButtonPressed(sender: AnyObject) {
        self.activityIndicator.startAnimating()
        
        let username = usernameField.text
        let password = passwordField.text
        
        //request to login user
        ClientHelper.sharedInstance().userLogin(username!, password: password!) { (result, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    ClientHelper.sharedInstance().showAlert(error!, viewController: self)
                })
            }
            else {
                // show map tab view
                
                ClientHelper.sharedInstance().studentKey = result!
                dispatch_async(dispatch_get_main_queue(), {
                    print("OK - key = \(ClientHelper.sharedInstance().studentKey)")
                    // log in, go to next view
                    self.goToNextView()
                })
            }
        }
    }
    
    // go to next view
    func goToNextView() {
        self.activityIndicator.stopAnimating()
        let tabBarController:UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    // sign up for Udacity
    @IBAction func signUp(sender: AnyObject) {
        let udacityWebsite = "http://www.udacity.com/account/auth#!/signup"
        ClientHelper.sharedInstance().openURL(udacityWebsite)
    }
    
    // MARK: - Keyboard Functions
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

}

