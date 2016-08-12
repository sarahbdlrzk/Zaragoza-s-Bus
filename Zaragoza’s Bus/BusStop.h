//
//  BusStop.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/11/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BusStop : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *busId;
@property (nonatomic,strong) NSNumber *lon;
@property (nonatomic,strong) NSNumber *lat;
@property (nonatomic,strong) NSString *timeToArraive;
@property (nonatomic,strong) UIImage *map;
@property (nonatomic,strong) NSMutableArray *estimates;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
