//
//  Utilities.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities
+(void) logError:(NSError*) error{
    NSLog(@" error => %@ ", [error userInfo] );
}

+(void) logObject:(NSObject*) object{
    NSLog(@" object => %@ ", [object description] );
}


+(void) logString:(NSString*) string{
    NSLog(@" object => %@ ", string);
}


@end
