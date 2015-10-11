//
//  PopUpViewController.m
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation PopUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstNameLabel.text = self.ride.driver.username;
    self.priceLabel.text = [NSString stringWithFormat:@"%f", self.ride.price];
}

- (IBAction)dismiss:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)requestRide:(UIButton *)sender {
    
}


@end
