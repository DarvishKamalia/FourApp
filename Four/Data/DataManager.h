//
//  ParseManager.h
//  Four
//
//  Created by Bohui Moon on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DataManager : NSObject

+ (instancetype)sharedManager;

- (void)createRideWithStart:(CLLocation *)start
                destination:(CLLocation *)destination
                      price:(float)price
                      seats:(int)seats
                      block:(void (^)(NSError *error))block;

@end
