//
//  RideAnnotation.m
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "RideAnnotation.h"

@implementation RideAnnotation

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) cooridinate
{
    self = [super init];
    if (self) {
        self.coordinate = cooridinate;
    }
    return self;
}

- (instancetype) initWithRide:(Ride *)ride
{
    self = [super init];
    if (self) {
        self.ride = ride;

        PFGeoPoint* start = self.ride.start[@"geopoint"];
        self.coordinate = CLLocationCoordinate2DMake(start.latitude, start.longitude);
        NSLog(@"%f", self.coordinate.latitude);
    }
    return self;
}

@end
