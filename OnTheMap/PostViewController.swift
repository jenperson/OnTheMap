//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/28/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController, MKMapViewDelegate {

    // MARK: Properties
    
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees = CLLocationDegrees()
    
    // MARK: Outlets
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        changeVisibility(true)
        
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func findOnMapAction(sender: AnyObject) {
     if (!locationField.text!.isEmpty) {
     getGeocodLocation(locationField.text!)
     }
     else {
     locationField.becomeFirstResponder()
     }
     
    }
    
     // find user location via geocoder
     func getGeocodLocation(address : String) {
        activityIndicator.hidden = false
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
        if error != nil {
            ClientHelper.sharedInstance().showAlert(error!, viewController: self)
            self.activityIndicator.hidden = true
        } else {
            self.submitButton.hidden = false
            self.websiteField.hidden = false
     
            let placemark = placemarks![0]
            self.latitude = placemark.location!.coordinate.latitude
            self.longitude = placemark.location!.coordinate.longitude
            self.placeMarkerOnMap(placemark)
        
            self.activityIndicator.hidden = true
            self.changeVisibility(false)
     }
     
     })
     }
    
    // Set marker on map and zoom in
    func placeMarkerOnMap(placemark: CLPlacemark) {
        // set zoom
        let latDelta : CLLocationDegrees = 0.01
        let longDelta : CLLocationDegrees = 0.01
        
        // make span
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        // create location
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        // create region
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        
        map.addAnnotation(MKPlacemark(placemark: placemark))
    }

    
    @IBAction func submitAction(sender: AnyObject) {
        // get public data udacity
        if (!websiteField.text!.isEmpty) {
            
            if (self.isValidURL(websiteField.text!)) {
                // user data
                sendUserLocation()
            }
            else {
                let error = NSError(domain: "Invalid URL", code: 0, userInfo: ["NSLocalizedDescriptionKey" : "Invalid URL"])
                ClientHelper.sharedInstance().showAlert(error, viewController: self)
            }
        }
        else {
            websiteField.becomeFirstResponder()
        }
    }
    
    func changeVisibility(firstStep: Bool) {
        locationField.hidden = !firstStep
        websiteField.hidden = firstStep
        
        if (firstStep) {
            studyLabel.text = "Where are you studying today?"
        } else {
            studyLabel.text = "Enter associated link"
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.cancel()
    }
    
    // go back to map view
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // validate url
    func isValidURL(urlString: String) -> Bool {
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        return NSURLConnection.canHandleRequest(request)
    }
    
    // get user data from udacity and post user location to parse
    func sendUserLocation() {
        activityIndicator.hidden = false
        
        var userData : [String: AnyObject] = [String: AnyObject]()
        
        ClientHelper.sharedInstance().getUserPublicData(ClientHelper.sharedInstance().studentKey, completionHandler: { userInformation, error in
            if userInformation != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    

                    if let firstName = userInformation?.firstName {
                    
                    userData  = [
                        ClientHelper.JSONKeys.UniqueKey: ClientHelper.sharedInstance().studentKey,
                        ClientHelper.JSONKeys.FirstName: firstName,
                        ClientHelper.JSONKeys.LastName: userInformation!.lastName,
                        ClientHelper.JSONKeys.MapString: self.locationField.text!,
                        ClientHelper.JSONKeys.MediaURL: self.websiteField.text!,
                        ClientHelper.JSONKeys.Latitude: self.latitude,
                        ClientHelper.JSONKeys.Longitude: self.longitude
                    ]
                    }
                    
                    //send request to parse
                    ClientHelper.sharedInstance().sendUserLocation(userData, completionHandler: { (result, error) -> Void in
                        if error != nil {
                            self.activityIndicator.hidden = true
                            dispatch_async(dispatch_get_main_queue(), {
                            ClientHelper.sharedInstance().showAlert(error!, viewController: self)
                            })
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.activityIndicator.hidden = true
                                self.cancel()
                            })
                        }
                    })
                })
            } else {
                if error != nil {
                        self.activityIndicator.hidden = true
                    dispatch_async(dispatch_get_main_queue(), {
                        ClientHelper.sharedInstance().showAlert(error!, viewController: self)
                    })
                }
            }
        })
    }
}
