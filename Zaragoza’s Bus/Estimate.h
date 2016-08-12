//
//  Estimate.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/12/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Estimate : NSObject
@property (nonatomic,strong) NSString *line;
@property (nonatomic,strong) NSString *direction;
@property (nonatomic,strong) NSNumber *estimate;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
