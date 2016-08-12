//
//  NotificationKeys.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationKeys : NSObject
extern NSString *const BusStopListLoadedKey;
extern NSString *const BusStopListLoadingFailedKey;
extern NSString *const BusStopRealTimeLoadedKey;
extern NSString *const BusStopRealTimeLoadingFailedKey;
@end
