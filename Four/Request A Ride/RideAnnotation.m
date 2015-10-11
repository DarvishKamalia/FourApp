//
//  RideAnnotation.m
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "RideAnnotation.h"

@interface RideAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) CLLocationCoordinate2D end;
@property (strong, nonatomic, readwrite) Ride* ride;

@end

@implementation RideAnnotation

- (instancetype) initWithRide:(Ride *)ride
{
    self = [super init];
    if (self) {
        self.ride = ride;
        self.coordinate = ride.start.coordinate;
        self.end = ride.destination.coordinate;
    }
    return self;
}

@end
