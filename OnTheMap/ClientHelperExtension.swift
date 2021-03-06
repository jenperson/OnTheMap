//
//  ClientHelperExtension.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/7/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: - Convenient Resource Methods

extension ClientHelper {
    
    // MARK: - POST Convenience Methods
    
    func userLogin(email: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void) {
        // method
        let method = Methods.CreateSession
        
        var parameters : [String:String] = [JSONKeys.Password : password]
            parameters[JSONKeys.Username] = email
        
        let jsonBody : [String:AnyObject] = [
            JSONKeys.Udacity: parameters
        ]
        // make the request
        taskForPOSTMethod(Server.Udacity, method: method, parameters: parameters, jsonBody: jsonBody, subdata: 5) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let error = result.valueForKey(JSONResponseKeys.Error)  as? String {
                    completionHandler(result: nil, error: NSError(domain: "udacity login issue", code: 0, userInfo: [NSLocalizedDescriptionKey: error]))
                }
                else {
                    let session = result["account"] as! NSDictionary
                    let key = session["key"] as! String
                    completionHandler(result: key, error: nil)
                }
            }
        }
    }
    
    // download student locations
    func getStudentLocations(completionHandler: (result: [UserInfo]?, error: NSError?) -> Void) {
        // make the request
        taskForGETMethod(Server.Parse, method: Methods.limit, parameters: ["limit":100,"order":"-updatedAt"]) { (result, error) -> Void in
            if error != nil || result == nil {
                completionHandler(result: nil, error: error)
            } else {
                if let locations = result as? [NSObject: NSObject] {
                    if let usersResult = locations["results"] as? [[String : AnyObject]] {
                        let studentsData = UserInfo.convertFromDictionaries(usersResult)
                        completionHandler(result: studentsData, error: nil)
                    }
                }
            }
        }
    }
    
    // get user data from udacity
    func getUserPublicData(userId: String, completionHandler: (result: PublicUserInfo?, error: NSError?) -> Void) {
        // method
        let method = Methods.Users + userId
        
        // make the request
        taskForGETMethod(Server.Udacity, method: method, parameters: ["":""]) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let data = result["user"] as? NSDictionary {
                    let studentsData = PublicUserInfo(dictionary: data)
                    completionHandler(result: studentsData, error: nil)
                }
            }
        }
    }
    
    // post user location to parse
    func sendUserLocation(userDetails: [String : AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        let parameters = userDetails
        
        // make the request
        taskForPOSTMethod(Server.Parse, method: "", parameters: ["":""], jsonBody: parameters, subdata: 0, completionHandler: { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: result, error: nil)
                
            }
        })
    }
    
    func removeAnnotations(mapView: MKMapView) {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
    }
    
    // set annotations for map with UserInfo
    func createAnnotations(users: [UserInfo], mapView: MKMapView) {
        
        for user in users {
            // set pin location
            let annotation = MKPointAnnotation()
             
            annotation.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude)
            annotation.title = "\(user.firstName) \(user.lastName)"
            annotation.subtitle = user.mediaURL
            
            mapView.addAnnotation(annotation)
        }
    }
    
    // request logout of udacity
    func logoutRequest(completionHandler: (result: AnyObject?, error: NSError?)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Udacity.ApiScheme + Udacity.ApiHost + Udacity.ApiPath + Methods.CreateSession)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            completionHandler(result: newData, error: nil)
        }
        task.resume()
    }
    
    // log user out of Udacity, return to sign in screen
    func logout(viewController: AnyObject) {
                logoutRequest { (result, error) -> Void in
            if error != nil {
                self.showAlert(error!, viewController: viewController)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    viewController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
}