//
//  BusStopsService.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopsService : NSObject
+ (instancetype)sharedInstance ;
-(void) getBusStops;
@end
