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
import MapKit

let uberServerToken = "HsamnrlCAg6WYkv4t5oEcMalWaTlnUmFtGvT-BV6"
let uberAPIURL = "https://sandbox-api.uber.com/v1/"


class CreateRideVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var startAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var uberEstimateTextLabel: UILabel!
    @IBOutlet weak var pricePerSeatTextField: UITextField!
    @IBOutlet weak var availableSeatsField: UITextField!
    
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation? = nil
    
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
                
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        

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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let replaced = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
//         if (textField == self.startAddressTextField) {
//            
//            let request = MKLocalSearchRequest()
//            request.naturalLanguageQuery = replaced
//            request.region = MKCoordinateRegion(center: (currentLocation?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
//            
//            MKLocalSearch().startWithCompletionHandler({ (searchResponse, searchError) -> Void in
//                
//                if (searchError != nil) {
//                    
//                    for response in searchResponse. as! [MKMapItem] {
//                        
//                        let res = response
//                        
//                        print (res.placemark.subThoroughfare! + " " + res.placemark.thoroughfare!)
//                        
//                    }
//                    
//                }
//                
//            })
//            
//        }
        
        return true
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
