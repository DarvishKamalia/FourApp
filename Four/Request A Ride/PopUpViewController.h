//
//  PopUpViewController.h
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"

@interface PopUpViewController : UIViewController

// Pass in the model
@property (strong, nonatomic) Ride* ride;

@end
