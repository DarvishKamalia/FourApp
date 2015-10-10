//
//  CreateRideViewController.swift
//  Four
//
//  Created by Darvish Kamalia on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

import UIKit

class CreateRideViewController: UIViewController {

    @IBOutlet weak var startAddressTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var uberEstimateTextLabel: UILabel!
    @IBOutlet weak var pricePerSeatTextField: UITextField!
    
    @IBOutlet weak var createRideButton: UIButton!
    
    @IBAction func createRideButtonPressed(sender: AnyObject) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
