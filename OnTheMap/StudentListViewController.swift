//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/7/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let client = OTMClient.sharedInstance()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if client.students.isEmpty {
            progressIndicator.startAnimating()
            fetchDataFromParse()
        }
        
    }
    
    private func fetchDataFromParse() {
        
        client.taskForParseGetMethod(OTMConstants.Methods.StudentsURL) { (result, error) in
            
            func displayError(error: String) {
                performUIUpdatesOnMain({
                    self.progressIndicator.stopAnimating()
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
            
            let aStudent = Student(firstName: firstName!, lastName: lastName!, mediaURL: mediaURL!, latitude: latitude!, longitude: longitude!)
            client.students.append(aStudent)
            
        }
        
        performUIUpdatesOnMain { 
            
            self.progressIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return client.students.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellid")!
        
        let name = "\(client.students[indexPath.row].firstName) \(client.students[indexPath.row].lastName)"
        
        cell.textLabel?.text = name
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = client.students[indexPath.row]
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.mediaURL)!)
        
    }
    
    @IBAction func refresh(sender: AnyObject) {
        
        progressIndicator.startAnimating()
        // refetch the data from parse
        fetchDataFromParse()
    }
    
}
