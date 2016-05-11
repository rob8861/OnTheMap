//
//  Student.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/8/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import Foundation

struct Student {
    
    var firstName: String
    var lastName: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var uniqueKey: String
    
    init(firstName: String, lastName: String, mediaURL: String, latitude: Double, longitude: Double, uniqueKey: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.uniqueKey = uniqueKey
    }
}