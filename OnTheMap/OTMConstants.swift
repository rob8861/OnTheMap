//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/7/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//


struct OTMConstants {
    
    static let AuthenticationURL = "https://www.udacity.com/api/session"
    
    
    struct Keys {
        
        static let Host = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let Session = "session"
        static let Id = "id"
        
        static let Results = "results"
        
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
    
    struct Methods {
        
        static let StudentsURL = "https://api.parse.com/1/classes/StudentLocation"
    }
}