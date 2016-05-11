//
//  GeocodeViewController.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/9/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import UIKit
import CoreLocation

class GeocodeViewController: UIViewController {
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    @IBOutlet weak var locationText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        // dismiss the view
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func userTappedView(sender: AnyObject) {
        
        if locationText.isFirstResponder() {
            locationText.resignFirstResponder()
        }
    }
    
    @IBAction func findLocation(sender: AnyObject) {
        
        decodeGeoLocation()
    }
    
    private func decodeGeoLocation() {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationText.text!) { (placemark, error) in
            
            func displayError(error: String) {
                performUIUpdatesOnMain({
                    let controller = UIAlertController(title: "Geocoder Error", message: error, preferredStyle: .Alert)
                    controller.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }
            
            if error != nil {
                displayError((error?.localizedDescription)!)
                return
            }
            
            guard let placemark = placemark else {
                displayError("Failed to decode location. Please try again!")
                return
            }
            
            let clPlacemark = placemark[0]
            
            self.lat = (clPlacemark.location?.coordinate.latitude)!
            self.lon = (clPlacemark.location?.coordinate.longitude)!
            
            // at this point we can instantiate the next view controller.
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapPreviewViewController") as! MapPreviewViewController
            controller.latitude = self.lat
            controller.longitude = self.lon
            controller.mapString = self.locationText.text!
            self.presentViewController(controller, animated: true, completion: nil)
            
        }
    }
}
