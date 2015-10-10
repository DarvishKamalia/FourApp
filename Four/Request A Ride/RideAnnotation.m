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

@end
