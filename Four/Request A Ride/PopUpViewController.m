//
//  PopUpViewController.m
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "PopUpViewController.h"
#import "DataManager.h"

@interface PopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) CLGeocoder* geocoder;

@end

@implementation PopUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.startLocationLabel.text = @"";
    self.destinationLocationLabel.text = @"";
    
    [self.geocoder reverseGeocodeLocation:self.ride.start completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if ([placemarks count] > 0) {
            CLPlacemark* placemark = placemarks[0];
            NSString* location = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            self.startLocationLabel.text = location;
        }
        
        [self.geocoder reverseGeocodeLocation:self.ride.destination completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if ([placemarks count] > 0) {
                CLPlacemark* placemark = placemarks[0];
                NSString* location = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                self.destinationLocationLabel.text = location;
            }
            
        }];
    }];
    
    self.firstNameLabel.text = self.ride.driver.username;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", self.ride.price];
}

#pragma mark - IBActions

- (IBAction)dismiss:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)requestRide:(UIButton *)sender {
    [[DataManager sharedManager] createRideRequest:self.ride block:^(NSError *error) {
        NSLog(@"%@", error);
        if (!error) {
            // Successful
            NSLog(@"Ride successfull");
        }
    }];
}

@end
