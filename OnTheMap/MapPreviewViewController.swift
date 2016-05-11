//
//  MapPreviewViewController.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/9/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import UIKit
import MapKit

class MapPreviewViewController: UIViewController, MKMapViewDelegate {
    
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(latitude!)
        let long = CLLocationDegrees(longitude!)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // dissmiss the keyboard when user touches the blue view
    @IBAction func userTappedView(sender: AnyObject) {
        
        if mediaURL.isFirstResponder() {
            mediaURL.resignFirstResponder()
        }
    }
    
    // this is where we call the Parse API to submit the student location
    @IBAction func submitLocation(sender: AnyObject) {
        
        var client = OTMClient.sharedInstance()
        
        var json = "{\"uniqueKey\": \"\(client.udacityUserID!)\", \"firstName\": \"\(client.udacityFirstName!)\", \"lastName\": \"\(client.udacityLastName!)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL.text!)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}"
        
        client.taskForParsePOSTMethod(OTMConstants.Methods.StudentsURL, jsonBody: json) { (result, error) in
            
            func displayError(error: String) {
                performUIUpdatesOnMain({
                    let controller = UIAlertController(title: "Student location submission error", message: error, preferredStyle: .Alert)
                    controller.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }
            
            if error != nil {
                displayError((error?.localizedDescription)!)
                return
            }
            
            // dismiss the view
            /*
             * two possible solutions: 
             * 1) use unwind segue 
             * 2) use self.presentingViewController and then dismiss view in view will appear.
             */
            performUIUpdatesOnMain({ 
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
        }
    }
    
    // MARK: MapKit Delegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
