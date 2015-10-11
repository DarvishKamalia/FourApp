//
//  Ride.h
//  Four
//
//  Created by Bohui Moon on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

/**
 *
 */
@interface Ride : NSObject

@property (nonatomic, strong) PFObject *const pfRide;
@property (nonatomic, strong) PFGeoPoint *const startGP;
@property (nonatomic, strong) PFGeoPoint *const destinationGP;

@property (nonatomic, strong) CLLocation *const start;
@property (nonatomic, strong) CLLocation *const destination;
@property (nonatomic, strong) PFUser  *const driver;
@property (nonatomic, strong) NSArray *riders;
@property (nonatomic, strong) NSDate  *const departure;
@property (nonatomic) const float price;
@property (nonatomic) BOOL completed;
@property (nonatomic) int seatsLeft;


- (instancetype)initWithRide:(PFObject *)ride;

@end
