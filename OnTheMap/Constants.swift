//
//  Constants.swift
//  OnTheMap
//
//  Created by Jennifer Person on 8/6/16.
//  Copyright © 2016 Jennifer Person. All rights reserved.
//


// MARK: - Constants

extension ClientHelper {

    // MARK: Udacity
    struct Udacity {
        static let ApiScheme = "https://"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/"
    }
    
    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Server
    struct Server {
        static let Udacity = "udacity"
        static let Parse = "parse"
    }
    
    // MARK: Parse
    struct Parse {
        static let ApiScheme = "https://"
        static let ApiHost = "parse.udacity.com/parse/classes"
        static let ApiPath = "/StudentLocation"
    }
    
    // MARK: Parse Parameter Keys
    struct ParseParameterKeys {
        static let ApiKey = "api_key"
        static let AppID = "app_id"
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Parse Parameter Values
    struct ParseParameterValues {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    // MARK: - Methods
    struct Methods {
        // get udacity session
        static let CreateSession : String = "session"
        // get public users data
        static let Users : String = "users/"
        // parse limit
        static let limit : String = ""
    }
    
    // MARK: - JSON Body Keys
    struct JSONKeys {
        // udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // parse
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        static let Error = "error"
        static let Status = "status"
        
        // MARK: Student information
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaUrl = "mediaURL"
        
    }
}
