//
//  MapKitViewController.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/7/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let client = OTMClient.sharedInstance()
    var annotations = [MKPointAnnotation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if client.students.isEmpty {
            
            fetchDataFromParse()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchDataFromParse() {
        
        client.taskForParseGetMethod(OTMConstants.Methods.StudentsURL) { (result, error) in
            
            func displayError(error: String) {
                performUIUpdatesOnMain({
                    let controller = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
                    controller.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }
            
            if (error != nil) {
                // display an error message
                displayError((error?.localizedDescription)!)
                return
            }
            
            if result == nil {
                displayError("Failed to parse data")
                return
            }
            
            self.saveStudents(result)
        }
        
    }
    
    private func saveStudents(results: AnyObject?) {
        
        let studentsResults = results![OTMConstants.Keys.Results] as? [[String:AnyObject]]
        
        guard let students = studentsResults else {
            return
        }
        
        client.students.removeAll()
        for student in students {
            
            let firstName = student[OTMConstants.Keys.FirstName] as? String
            let lastName = student[OTMConstants.Keys.LastName] as? String
            let mediaURL = student[OTMConstants.Keys.MediaURL] as? String
            let latitude = student[OTMConstants.Keys.Latitude] as? Double
            let longitude = student[OTMConstants.Keys.Longitude] as? Double
            let uniqueKey = student[OTMConstants.Keys.UniqueKey] as? String
            
            let aStudent = Student(firstName: firstName!, lastName: lastName!, mediaURL: mediaURL!, latitude: latitude!, longitude: longitude!, uniqueKey: uniqueKey!)
            client.students.append(aStudent)
            
        }
        
        // populate the map
        populateTheMap()
    }
    
    private func populateTheMap() {
        
        annotations.removeAll()
        for student in client.students {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        performUIUpdatesOnMain { 
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    // MARK : MapKit Delegate Methods
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        
        fetchDataFromParse()
    }
}
