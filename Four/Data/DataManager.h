//
//  ParseManager.h
//  Four
//
//  Created by Bohui Moon on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Ride.h"


/**
 *
 */
@interface DataManager : NSObject

+ (instancetype)sharedManager;


//creating a new ride
- (void)createRideWithStart:(CLLocation *)start destination:(CLLocation *)destination
                  departure:(NSDate *)departure
                      price:(float)price seats:(int)seats
                      block:(void (^)(NSError *error))block;

- (void)createRideRequest:(Ride *)rideObj block:(void (^)(NSError *error))block;


//getting rides near a location
- (void)getRidesStartingNear:(CLLocation *)location within:(double)miles
                       block:(void (^)(NSArray *rides, NSError *error))block;
- (void)getRidesEndingNear:(CLLocation *)location within:(double)miles
                     block:(void (^)(NSArray *rides, NSError *error))block;


@end
