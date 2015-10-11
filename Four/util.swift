//
//  util.swift
//  IronLogs
//
//  Created by Darvish Kamalia on 7/24/15.
//  Copyright (c) 2015 Darvish Kamalia. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

extension String {
    func toInt32() -> Int32? {
        return NSNumberFormatter().numberFromString(self)?.intValue
    }
}

func stringFromDate(input: NSTimeInterval) -> String {
    
    let formatter = NSDateFormatter()
    let date = NSDate(timeIntervalSince1970: input)
    formatter.dateStyle = NSDateFormatterStyle.MediumStyle
    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
    return formatter.stringFromDate(date)
    
}

func shortStringFromDate (input: NSTimeInterval) -> String {
    
    let formatter = NSDateFormatter()
    let date = NSDate(timeIntervalSince1970: input)
    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
    return formatter.stringFromDate(date)
    
}


func poundsToKilos (input: Double) -> Double {
    
    return round(input * 0.453)
}

func KilosToPounds (input: Double) -> Double {
    
    return round(input/0.453)
    
}

func createAlert (title: String, message: String) -> UIAlertController {
    
    let vc =  UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    vc.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
    return vc
    
}

func getTimeEstimateBetweenLocation(start: CLLocation, end: CLLocation, completion: (time: Int) -> Void) {
    
    let uberServerToken = "HsamnrlCAg6WYkv4t5oEcMalWaTlnUmFtGvT-BV6"
    let uberAPIURL = "https://sandbox-api.uber.com/v1/"
    
    Alamofire.request(Method.GET, uberAPIURL + "estimates/time", parameters: [
        
        "server_token" : uberServerToken,
        "start_latitude" : start.coordinate.latitude,
        "start_longitude" : start.coordinate.longitude,
        "end_latitude" : end.coordinate.latitude,
        "end_longitude" : end.coordinate.longitude
        
        ]).responseJSON {
            
            (response) in
            
            if let value = response.result.value {
                
                let json = JSON(value)
                print (json)
                let estimate = json["times"][0]["estimate"].int
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    completion(time: estimate!)
                    
                })
                
                
                
            }
            
            
    }
    
}