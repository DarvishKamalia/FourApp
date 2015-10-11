//
//  Ride.m
//  Four
//
//  Created by Bohui Moon on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "Ride.h"


@interface Ride()


@end


@implementation Ride
#pragma mark Init
/**
 *
 */
- (instancetype)initWithRide:(PFObject *)ride
{
    if (self = [super init])
    {
        self.pfRide = ride;
    
        self.startGP = ride[@"start"][@"geopoint"];
        self.destinationGP = ride[@"destination"][@"geopoint"];
        
        self.start = [[CLLocation alloc] initWithLatitude:self.startGP.latitude longitude:self.startGP.longitude];
        self.destination = [[CLLocation alloc] initWithLatitude:self.destinationGP.latitude longitude:self.destinationGP.longitude];
        
        self.driver = ride[@"driver"];
        self.riders = ride[@"riders"];
        
        self.departure = ride[@"departure"];
        self.price = [ride[@"price"] floatValue];
        self.completed = [ride[@"completed"] boolValue];
    }
    return self;
}

@end
