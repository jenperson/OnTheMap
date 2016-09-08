//
//  PublicUserInfo.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/7/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//

import Foundation

struct PublicUserInfo {
    var firstName = ""
    var lastName = ""
    
    /* Construct a PublicUserInformation from a dictionary */
    init(dictionary: NSDictionary) {
        firstName = dictionary["first_name"] as! String
        lastName = dictionary["last_name"] as! String
    }
}
