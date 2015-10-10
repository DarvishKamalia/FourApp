//
//  ParseManager.m
//  Four
//
//  Created by Bohui Moon on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "DataManager.h"


@interface DataManager()



@end


@implementation DataManager
#pragma mark Init
/**
 * Returns singleton instance of ParseManager.
 * This class should not be instantiated locally.
 */
+ (id)sharedManager
{
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


#pragma mark - Methods
/**
 * Create a new PFObject Ride with the given parameters, and save.
 */
- (void)createRideWithStart:(CLLocation *)start destination:(CLLocation *)destination price:(float)price seats:(int)seats
                      block:(void (^)(NSError *error))block
{
    PFGeoPoint *startGP = [PFGeoPoint geoPointWithLocation:start];
    PFGeoPoint *destGP  = [PFGeoPoint geoPointWithLocation:destination];
    
    PFObject *startLoc = [PFObject objectWithClassName:@"Location"];
    startLoc[@"point"] = startGP;
    PFObject *destLoc  = [PFObject objectWithClassName:@"Location"];
    destLoc[@"point"]  = destGP;
    
    PFUser *driver = [PFUser currentUser];
    
    NSNumber *priceObj = [NSNumber numberWithFloat:price];
    NSNumber *seatsObj = [NSNumber numberWithInt:seats];
    
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"start"] = startLoc;
    newRide[@"destination"] = destLoc;
    newRide[@"driver"] = driver;
    newRide[@"riders"] = [NSArray array];
    newRide[@"price"] = priceObj;
    newRide[@"seatsLeft"] = seatsObj;
    
    [newRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            //error handler;
            block(error);
            return;
        }
        
        block(nil);
    }];
}

@end
