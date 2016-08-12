//
//  BusStop.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/11/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import "BusStop.h"
#import "JsonKeys.h"
@implementation BusStop

@synthesize busId,title,lon,lat,map,estimates;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.busId = dictionary[BusId];
        self.title = dictionary[Title];
        self.lon = dictionary[Lon];
        self.lat = dictionary[Lat];
        self.timeToArraive=@"";
        self.estimates=nil;
    }
    return self;
}

@end
