//
//  BusStopParser.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/11/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopParser : NSObject
+(NSMutableArray*) parseJsonResponse:(NSData*) data;
@end
