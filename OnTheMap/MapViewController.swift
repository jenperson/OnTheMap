//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/13/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add pin button
        let pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.addPin))
        
        // add refresh button
        let refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(MapViewController.reloadAction))
        
        
        // add the buttons
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Done, target: self, action: #selector(MapViewController.logout))
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadUsersData()
    }
    
    func addPin() {
        let postController:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Study Location")
            self.navigationController?.presentViewController(postController, animated: true, completion: nil)
    }
    
    func reloadAction() {
        self.reloadUsersData()
    }
    
    //reload users data
    func reloadUsersData() {
        ClientHelper.sharedInstance().removeAnnotations(self.map)
        
        ClientHelper.sharedInstance().getStudentLocations { users, error in
            if let usersData =  users {
                dispatch_async(dispatch_get_main_queue(), {
                    ClientHelper.sharedInstance().usersData = usersData
                    ClientHelper.sharedInstance().createAnnotations(usersData, mapView: self.map)
                })
            } else {
                if error != nil {
                    ClientHelper.sharedInstance().showAlert(error!, viewController: self)
                }
            }
        }
    }
    
    // setup pin properties
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinView.pinTintColor = UIColor.redColor()
            pinView.canShowCallout = true
            
            // pin button
            let pinButton = UIButton(type: UIButtonType.InfoLight)
            pinButton.frame.size.width = 44
            pinButton.frame.size.height = 44
            
            pinView.rightCalloutAccessoryView = pinButton
            
            return pinView
        }
        return nil
    }
    
    // click to pin
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // open url
        if let pinURL = view.annotation?.subtitle {
        ClientHelper.sharedInstance().openURL(pinURL!)
        } else {
            print("URL not valid")
        }
    }
    
    func logout() {
        ClientHelper.sharedInstance().logout(self)
    }
}

