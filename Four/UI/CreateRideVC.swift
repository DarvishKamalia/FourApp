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
    
    var topButton: UIButton? = nil
    var bottomButton: UIButton? = nil
    
    
    let locationManager = CLLocationManager()
    
    
    var firstFieldItem: MKMapItem? = nil
    var secondFieldItem: MKMapItem? = nil

    
    @IBAction func createRideButtonPressed(sender: AnyObject) {
        
        let coder = CLGeocoder()
        coder.geocodeAddressString(startAddressTextField.text!, completionHandler: { (startMarks, error) -> Void in
            
            if let startMark = startMarks?.first! {
                
                coder.geocodeAddressString(self.destinationAddressTextField.text!, completionHandler: { (endMarks, error) -> Void in
                    
                    if let endMark = endMarks?.first {
                    
                        DataManager.sharedManager().createRideWithStart(startMark.location, destination: endMark.location, departure: self.departureDatePicker.date, price: Float((self.pricePerSeatTextField.text?.toDouble())!), seats: (self.availableSeatsField.text?.toInt32())!, block: { (error) -> Void in
                            
                            if (error == nil){
                                self.presentViewController(createAlert("Success", message: "Ride Created!"), animated: true, completion: nil)
                                self.dismissViewControllerAnimated(true, completion: nil)
                                
                            }
                            
                            else {
                                
                                
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
        
        
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
            
    
        
    
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        topButton?.hidden = true
        topButton?.hidden = true
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.topButton?.hidden = true
        self.bottomButton?.hidden = true
        
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
                                       // print (json)
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
        
         if (textField.text?.characters.count > 6) {
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = replaced
            if (locationManager.location == nil) {
                print ("nil location")
                return true
            }
            
            request.region = MKCoordinateRegion(center: (locationManager.location?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
            
            let search = MKLocalSearch(request: request)
            
            search.startWithCompletionHandler({ (searchResponse, searchError) -> Void in
                
               // print ("started search")
                if (searchError == nil) {
                    
                    if let msR = searchResponse {
                       
                        if (msR.mapItems.count > 0) {
                            
                            var toChange: UITextField = textField
                            
                            var toChangeButton: UIButton! = nil
                            var item: MKMapItem! = nil
                            
                            if (toChange == self.startAddressTextField) {
                                toChangeButton = self.topButton
                                item = self.firstFieldItem
                            }
                            
                            else {
                                
                                toChangeButton = self.bottomButton
                                item = self.secondFieldItem
                            }
                            
                            item = msR.mapItems[0]
                            
                            toChangeButton?.hidden = true
                            
                            if (toChangeButton == nil) {
                                
                                toChangeButton = UIButton(frame: CGRect(x: textField.frame.origin.x, y: textField.frame.origin.y + textField.frame.height, width: textField.frame.width, height: 20))
                                
                            }
                            
                          toChangeButton!.setTitle(self.getStringFromPlacemark(item!.placemark), forState: .Normal)
                            
                            if (self.getStringFromPlacemark(item.placemark) == "") {
                                return
                            }
                            toChangeButton?.backgroundColor = UIColor.blackColor()
                            toChangeButton!.addTarget(self, action: "suggestionSelected:", forControlEvents: .TouchUpInside)
                            toChangeButton?.hidden = false
                            self.view.addSubview(toChangeButton!)
                        }
                        
                    }
                    
                    else {
                        print ("no response")
                    }
                    
                }
                
                else {
                    
                    print(searchError!.localizedDescription)
                }
                
            })
            
        }
        
        return true
        
        
    }
    
    //TableView methods
    
    func suggestionSelected (sender: UIButton) {
        
        sender.hidden = true
        
        if (self.startAddressTextField.editing) {
            
            if let pm = firstFieldItem?.placemark{
                
                self.startAddressTextField.text = self.getStringFromPlacemark(pm)
                print ("setting text")

            }
            
        }
        else {
            
            if let pm = secondFieldItem?.placemark {
                self.destinationAddressTextField.text = self.getStringFromPlacemark(pm)
            }
        }
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("updated location")
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getStringFromPlacemark (placemark : CLPlacemark) -> String {
        var localityString = "";
        
        if (placemark.locality == nil || placemark.postalCode == nil || placemark.subThoroughfare == nil || placemark.thoroughfare == nil) {
            
            return ""
        }
        
        else {
            
            localityString = ", " + (placemark.locality)! + ", " + (placemark.postalCode)!
            return placemark.subThoroughfare! + " " + placemark.thoroughfare! + localityString
            
        }
        
        
    }
}
