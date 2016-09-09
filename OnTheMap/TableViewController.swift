//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/13/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var mainTable: UITableView!

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableViewController.addPin))
        
        let refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(TableViewController.reloadAction))
        
        
        // add the buttons
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Done, target: self, action: #selector(TableViewController.logout))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadData()
    }
    
    //action - add location for current user
    func addPin() {
        let postController:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Study Location")
            self.navigationController?.presentViewController(postController, animated: true, completion: nil)
    }
    
    //action - reload users location
    func reloadAction() {
        self.reloadData()
    }
    
    //action - logout
    @IBAction func logoutAction(sender: UIBarButtonItem) {
        ClientHelper.sharedInstance().logout(self)
    }
    
    // update to current user data
    func reloadData() {
        
        ClientHelper.sharedInstance().getStudentLocations { users, error in
            if let usersData =  users {
                dispatch_async(dispatch_get_main_queue(), {
                    ClientHelper.sharedInstance().usersData = usersData
                    self.mainTable.reloadData()
                })
            } else {
                if error != nil {
                    ClientHelper.sharedInstance().showAlert(error!, viewController: self)
                }
            }
        }
    }
    
    // MARK: - tableView functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientHelper.sharedInstance().usersData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserData", forIndexPath: indexPath)

        
        // set cell data
        let lastName = ClientHelper.sharedInstance().usersData[indexPath.row].lastName
        let firstName = ClientHelper.sharedInstance().usersData[indexPath.row].firstName


        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    // open selected url in safari
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ClientHelper.sharedInstance().openURL(ClientHelper.sharedInstance().usersData[indexPath.row].mediaURL)
    }
    
    func logout() {
        ClientHelper.sharedInstance().logout(self)
    }

}


