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
        PFGeoPoint *start = ride[@"start"];
        PFGeoPoint *dest  = ride[@"destination"];
        self.start = [[CLLocation alloc] initWithLatitude:start.latitude longitude:start.longitude];
        self.destination = [[CLLocation alloc] initWithLatitude:dest.latitude longitude:dest.longitude];
        
        self.driver = ride[@"driver"];
        self.riders = ride[@"riders"];
        
        self.departure = ride[@"departure"];
        self.price = [ride[@"price"] floatValue];
        self.completed = [ride[@"completed"] boolValue];
    }
    return self;
}

@end
