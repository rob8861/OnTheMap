//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/7/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
