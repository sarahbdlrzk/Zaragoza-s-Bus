//
//  BusStopsService.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

#import "BusStopsService.h"
#import "NotificationKeys.h"
#import "Utilities.h"
#import "BusStopParser.h"
#import "JsonKeys.h"

//NSString *const  BusStopServiceURL= @"http://www.dndzgz.com/fetch?service=bus";
NSString *const  BusStopServiceURL= @"http://api.dndzgz.com/services/bus";

@implementation BusStopsService

+ (instancetype)sharedInstance {
    static BusStopsService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BusStopsService alloc] init];
    });
    return sharedInstance;
}



-(void) getBusStops{
    
    NSURL *URL = [NSURL URLWithString:BusStopServiceURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          // Handle error...
                                          [[NSNotificationCenter defaultCenter] postNotificationName:BusStopListLoadingFailedKey object:nil];
                                          [Utilities logError:error];
                                          return;
                                      }
                                      //[Utilities logObject:response];

                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                     // [Utilities logString:body];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:BusStopListLoadedKey object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:[BusStopParser parseJsonResponse:data], BusStops, nil]];

                                      
                                  }];
    [task resume];
}
@end
