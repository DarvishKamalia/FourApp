//
//  CreateRideViewController.swift
//  Four
//
//  Created by Darvish Kamalia on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

import UIKit
import Alamofire

let uberServerToken = "HsamnrlCAg6WYkv4t5oEcMalWaTlnUmFtGvT-BV6"

class CreateRideViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var startAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var uberEstimateTextLabel: UILabel!
    @IBOutlet weak var pricePerSeatTextField: UITextField!
    
    @IBOutlet weak var createRideButton: UIButton!
    
    
    @IBAction func createRideButtonPressed(sender: AnyObject) {
        
        let url = "https://sandbox-api.uber.com/v1/products"
        

        
        Alamofire.request(.GET, url, parameters: ["server_token" : uberServerToken, "latitude" : 0.0 , "longitude" : 0.0], headers: ["server_token" : uberServerToken]).responseJSON(completionHandler: {
            
            (response) in
            
            if let JSON = response.result.value {
                
                print (JSON)
                
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
