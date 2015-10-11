//
//  RideAnnotation.h
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Ride.h"

@interface RideAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D end;
@property (strong, nonatomic, readonly) Ride* ride;

- (instancetype) initWithRide:(Ride *)object;

@end
