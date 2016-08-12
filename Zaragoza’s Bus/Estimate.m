//
//  Estimate.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/12/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import "Estimate.h"
#import "JsonKeys.h"

@implementation Estimate
@synthesize line,direction,estimate;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.line = dictionary[Line];
        self.direction = dictionary[Direction];
        if ([dictionary[EstimateKey] isKindOfClass:[NSNull class]]) {
            self.estimate = [NSNumber numberWithInteger:NSNotFound];
        }
        else{
            self.estimate = dictionary[EstimateKey];
        }
        
    }
    return self;
}
@end
