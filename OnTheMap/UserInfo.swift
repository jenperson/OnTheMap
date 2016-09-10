//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/7/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import Foundation
import MapKit

struct UserInfo {
    var firstName : String
    var lastName : String
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees =  CLLocationDegrees()
    var mediaURL : String
    //var usersData: [UserInfo] = [UserInfo]()
    
    /* Initial a student information from dictionary */
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[ClientHelper.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ClientHelper.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ClientHelper.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[ClientHelper.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mediaURL = dictionary[ClientHelper.JSONResponseKeys.MediaUrl] as! String
        }
    
    /* Convert an array of dictionaries to an array of student information struct objects */
    static func convertFromDictionaries(array: [[String : AnyObject]]) -> [UserInfo] {
        var resultArray = [UserInfo]()
        
        for dictionary in array {
            if dictionary[ClientHelper.JSONResponseKeys.FirstName] != nil {
            resultArray.append(UserInfo(dictionary: dictionary))
            }
        }
        
        return resultArray
    }
}

class AllUsersInfo {
    
    var listOfStudents : [UserInfo] = []
    var studentKey = ""
    
    static let sharedInstance = AllUsersInfo()
}
