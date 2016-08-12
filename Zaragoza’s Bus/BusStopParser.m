//
//  BusStopParser.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/11/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import "BusStopParser.h"
#import "BusStop.h"
#import "JsonKeys.h"
#import "Estimate.h"
@implementation BusStopParser
+(NSMutableArray*) parseJsonResponse:(NSData*) data{
    NSError *e;
    NSMutableDictionary*response= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&e];
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *locations=[response objectForKey:Locations] ;

        if (locations && [locations isKindOfClass:[NSArray class]]) {
            NSMutableArray *reponseObjects=[NSMutableArray arrayWithCapacity:[locations count]];
            for (int i=0; i<[locations count]; i++) {
                [reponseObjects addObject:[[BusStop alloc] initWithDictionary:[locations objectAtIndex:i]]];
            }
            return reponseObjects;
        }
    }
    return nil;
}


@end
