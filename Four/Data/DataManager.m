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
- (void)createRideWithStart:(CLLocation *)start destination:(CLLocation *)destination departure:(NSDate *)departure
                      price:(float)price seats:(int)seats
                      block:(void (^)(NSError *error))block
{
    //new ride
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];

    //geo locations
    PFGeoPoint *startGP = [PFGeoPoint geoPointWithLocation:start];
    PFGeoPoint *destGP  = [PFGeoPoint geoPointWithLocation:destination];
    
    PFObject *startLoc = [PFObject objectWithClassName:@"Start"];
    startLoc[@"geopoint"] = startGP;
    PFObject *destLoc  = [PFObject objectWithClassName:@"Destination"];
    destLoc[@"geopoint"] = destGP;
    
    
    //other fields
    PFUser *driver = [PFUser currentUser];
    
    NSNumber *priceObj = [NSNumber numberWithFloat:price];
    NSNumber *seatsObj = [NSNumber numberWithInt:seats];
    
    
    //configure rides
    newRide[@"start"] = startLoc;
    newRide[@"destination"] = destLoc;
    newRide[@"departure"] = departure;
    newRide[@"driver"] = driver;
    newRide[@"riders"] = [NSArray array];
    newRide[@"price"] = priceObj;
    newRide[@"seatsLeft"] = seatsObj;
    newRide[@"completed"] = [NSNumber numberWithBool:NO];
    
    //attempt saving ride
    [newRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            //error handler;
            block(error);
            return;
        }

        NSLog(@"%@", newRide.objectId);
        startLoc[@"ride"] = newRide;
        destLoc[@"ride"] = newRide;
        
        BOOL saved = [startLoc save] && [destLoc save];
        if (!saved)
        {
            [newRide delete];
            [startLoc delete];
            [destLoc delete];
            block([NSError errorWithDomain:@"couldn't save locations" code:0 userInfo:@{@"error":@"locations not saved"}]);
        }
        
        block(nil);
    }];
}


/**
 *
 */
- (void)createRideRequest:(Ride *)rideObj block:(void (^)(NSError *error))block
{
    PFUser *rider = [PFUser currentUser];

    PFObject *ride = rideObj.pfRide;
    int seatsLeft = rideObj.seatsLeft;
    if (seatsLeft == 0)
    {
        block([NSError errorWithDomain:@"Request error" code:0 userInfo:@{@"error":@"Not enough seats"}]);
        return;
    }
    
    NSMutableArray *riders = [NSMutableArray arrayWithArray:rideObj.riders];
    [riders addObject:rider];
    ride[@"riders"] = riders;
    
    ride[@"seatsLeft"] = [NSNumber numberWithInt:rideObj.seatsLeft];
    
    [ride saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            block(error);
            return;
        }
        
        NSMutableArray *taken = [NSMutableArray arrayWithArray:rider[@"taken"]];
        [taken addObject:ride];
        rider[@"taken"] = taken;
        
        NSError *saveError = nil;
        if (![rider save:&saveError])
        {
            block(saveError);
            return;
        }
        
        rideObj.riders = riders;
        rideObj.seatsLeft--;
        block(nil);
    }];
}


/**
 *
 */
- (void)getRidesStartingNear:(CLLocation *)location within:(double)miles
                       block:(void (^)(NSArray *rides, NSError *error))block
{
    PFGeoPoint *gp = [PFGeoPoint geoPointWithLocation:location];
    
    PFQuery *notCompleted = [PFQuery queryWithClassName:@"Ride"];
    [notCompleted whereKey:@"completed" equalTo:[NSNumber numberWithBool:NO]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Start"];
    [query whereKey:@"ride" matchesQuery:notCompleted];
    [query whereKey:@"geopoint" nearGeoPoint:gp withinMiles:miles];
    [query includeKey:@"ride"];
    [query includeKey:@"ride.driver"];
    [query includeKey:@"ride.start"];
    [query includeKey:@"ride.destination"];
    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            //error handling
            block(nil, error);
            return;
        }
        
        //success
        NSMutableArray *rides = [NSMutableArray array];
        for (PFObject *start in objects)
            [rides addObject: [[Ride alloc] initWithRide:start[@"ride"]]];
        
        block(rides, nil);
    }];
}


/**
 *
 */
- (void)getRidesEndingNear:(CLLocation *)location within:(double)miles
                       block:(void (^)(NSArray *rides, NSError *error))block
{
    PFGeoPoint *gp = [PFGeoPoint geoPointWithLocation:location];
    
    PFQuery *notCompleted = [PFQuery queryWithClassName:@"Ride"];
    [notCompleted whereKey:@"completed" equalTo:[NSNumber numberWithBool:NO]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Destination"];
    [query whereKey:@"ride" matchesQuery:notCompleted];
    [query whereKey:@"geopoint" nearGeoPoint:gp withinMiles:miles];
    [query includeKey:@"ride"];
    [query includeKey:@"ride.driver"];
    [query includeKey:@"ride.start"];
    [query includeKey:@"ride.destination"];
    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            //error handling
            NSLog(@"error");
            block(nil, error);
            return;
        }
        
        //success
        NSLog(@"%@", objects);
        NSMutableArray *rides = [NSMutableArray array];
        for (PFObject *dest in objects)
        {
            NSLog(@"%@", dest);
            [rides addObject: [[Ride alloc] initWithRide:dest[@"ride"]] ];
        }
        
        block(rides, nil);
    }];
}

@end









