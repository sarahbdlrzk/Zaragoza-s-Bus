//
//  BusStopInfoDownloader.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/12/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BusStop;
@interface BusStopInfoDownloader : NSObject

@property (nonatomic, strong) BusStop *busStop;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload:(long)busID;
- (void)cancelDownload;
@end
