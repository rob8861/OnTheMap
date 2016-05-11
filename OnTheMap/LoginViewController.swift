//
//  ViewController.swift
//  OnTheMap
//
//  Created by Rob Fazio on 5/4/16.
//  Copyright © 2016 Rob Fazio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        
        let client = OTMClient.sharedInstance()
        
        let json = "{\"udacity\": {\"\(OTMConstants.Keys.Username)\": \"\(email.text!)\", \"\(OTMConstants.Keys.Password)\": \"\(password.text!)\"}}"
        
        client.taskForPOSTMethod("", parameters: [:], jsonBody: json) { (result, error) in
            
            func displayError(error: String) {
                performUIUpdatesOnMain({ 
                    let controller = UIAlertController(title: "Login Error", message: error, preferredStyle: .Alert)
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
            
            var sessionDic = result[OTMConstants.Keys.Session] as? [String:String]
            client.udacitySessionID = sessionDic![OTMConstants.Keys.Id]
            
            // get the currect logged in user information
            client.taskForGETMethod(OTMConstants.Methods.CurrentUserURL, completionHandlerForPOST: { (result, error) in
                
                func displayError(error: String) {
                    performUIUpdatesOnMain({
                        let controller = UIAlertController(title: "Login Error", message: error, preferredStyle: .Alert)
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
                
                // extract the user infromation and store them in the client for later use
                var userInfo = result[OTMConstants.UdacityKeys.User] as? [String:AnyObject]
                
                client.udacityFirstName = userInfo![OTMConstants.UdacityKeys.FirstName] as? String
                client.udacityLastName = userInfo![OTMConstants.UdacityKeys.LastName] as? String
                client.udacityUserID = userInfo![OTMConstants.UdacityKeys.UserID] as? String
                
                // complete the login process and present the next view controller.
                performUIUpdatesOnMain({
                    self.loginCompleted()
                })
            })
        }
        
    }
    
    private func loginCompleted() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ManagerTabViewController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }

}

