//
//  RideAnnotation.h
//  Four
//
//  Created by Saurabh Jain on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RideAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) PFObject* ride;

- (instancetype) initWithRide:(PFObject *)object;
- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) cooridinate;

@end
