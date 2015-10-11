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

- (instancetype) initWithRide:(PFObject *)object
{
    self = [super init];
    if (self) {
        self.ride = object;
        PFObject* startLocation = object[@"start"];
        PFGeoPoint* geo = startLocation[@"geopoint"];
        self.coordinate = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
    }
    return self;
}

@end
