//
//  CreateRideViewController.swift
//  Four
//
//  Created by Darvish Kamalia on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

let uberServerToken = "HsamnrlCAg6WYkv4t5oEcMalWaTlnUmFtGvT-BV6"
let uberAPIURL = "https://sandbox-api.uber.com/v1/"


class CreateRideVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var startAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var uberEstimateTextLabel: UILabel!
    @IBOutlet weak var pricePerSeatTextField: UITextField!
    @IBOutlet weak var availableSeatsField: UITextField!
    
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    
    @IBAction func createRideButtonPressed(sender: AnyObject) {
        
        let coder = CLGeocoder()
        coder.geocodeAddressString(startAddressTextField.text!, completionHandler: { (startMarks, error) -> Void in
            
            if let startMark = startMarks?.first! {
                
                coder.geocodeAddressString(self.destinationAddressTextField.text!, completionHandler: { (endMarks, error) -> Void in
                    
                    if let endMark = endMarks?.first {
                    
                        DataManager.sharedManager().createRideWithStart(startMark.location, destination: endMark.location, departure: self.departureDatePicker.date, price: Float((self.pricePerSeatTextField.text?.toDouble())!), seats: (self.availableSeatsField.text?.toInt32())!, block: { (error) -> Void in
                            
                            if (error == nil){
                                self.presentViewController(createAlert("Success", message: "Ride Created Successfully"), animated: true, completion: nil)
                            }
                            
                            else {
                                
                                print ("damn")
                                
                            }
                            
                            
                            
                        })
                        
                        
                        
                    }
                        
                    else {
                        
                        print ("no end")
                    }
                    
                    
                })
                
            }
                
            else {
                
                print ("no start")
                
            }

        
        })
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == self.destinationAddressTextField) {
            
            let startAddress = self.startAddressTextField.text!
            let destinationAddress = self.destinationAddressTextField.text!
            
            
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge) as UIActivityIndicatorView
            
            spinner.frame = CGRect(x: 0, y: 0, width: uberEstimateTextLabel.frame.width, height: uberEstimateTextLabel.frame.height)
            uberEstimateTextLabel.text = ""
            uberEstimateTextLabel.addSubview(spinner)
            spinner.startAnimating()
            
            let coder = CLGeocoder()
            coder.geocodeAddressString(startAddressTextField.text!, completionHandler: { (startMarks, error) -> Void in
                
                if let startMark = startMarks?.first! {
                    
                    coder.geocodeAddressString(self.destinationAddressTextField.text!, completionHandler: { (endMarks, error) -> Void in
                        
                        if let endMark = endMarks?.first {
                            
                            Alamofire.request(Method.GET, uberAPIURL + "estimates/price", parameters: [
                            
                                "server_token" : uberServerToken,
                                "start_latitude" : startMark.location!.coordinate.latitude,
                                "start_longitude" : startMark.location!.coordinate.longitude,
                                "end_latitude" : endMark.location!.coordinate.latitude,
                                "end_longitude" : endMark.location!.coordinate.longitude

                                ]).responseJSON {
                                    
                                    (response) in
                                    
                                    if let value = response.result.value {
                                        
                                        let json = JSON(value)
                                        print (json)
                                        let estimate = json["prices"][0]["estimate"].string
                                        spinner.stopAnimating()
                                        self.uberEstimateTextLabel.text = estimate
                                        
                                        
                                    }
                                    
                                    
                                }
                            
                        }
                        
                        else {
                            
                            print ("no end")
                        }
                        
                        
                    })
                    
                }
                
                else {
                    
                    print ("no start")
                    
                }
            })
        
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
