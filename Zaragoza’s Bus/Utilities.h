//
//  Utilities.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(void) logError:(NSError*) error;
+(void) logObject:(NSObject*) object;
+(void) logString:(NSString*) string;
@end
