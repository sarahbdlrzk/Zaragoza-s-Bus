//
//  BusStopInfoDownloader.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/12/16.
//  Copyright © 2016 Sarah. All rights reserved.
//

/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Helper object for managing the downloading of a particular app's icon.
 It uses NSURLSession/NSURLSessionDataTask to download the app's icon in the background if it does not
 yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 */


#import "BusStopInfoDownloader.h"
#import "BusStop.h"
#import "Utilities.h"
#import "BusStopParser.h"
#import "Estimate.h"
#import "JsonKeys.h"
#define kAppIconSize 200
NSString *const  BusStopRealTimeServiceURL= @"http://api.dndzgz.com/services/bus";

@interface BusStopInfoDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation BusStopInfoDownloader
@synthesize busStop;

-(NSMutableArray*) parseInfoJsonResponse:(NSData*) data{
    NSError *e;
    NSDictionary*responseDictionary= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&e];
    if (responseDictionary && [responseDictionary isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *response=[responseDictionary objectForKey:Estimates];
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSMutableArray *reponseObjects=[NSMutableArray arrayWithCapacity:[response count]];
            for (int i=0; i<[response count]; i++) {
                NSMutableDictionary *lineEstimate=[response objectAtIndex:i];
                if (lineEstimate && [lineEstimate isKindOfClass:[NSDictionary class]]) {
                    [reponseObjects addObject:[[Estimate alloc] initWithDictionary:[response objectAtIndex:i]]];
                }
            }
            return reponseObjects;
            
        }
    }
    
    return nil;
}
// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload:(long)busID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%ld",BusStopRealTimeServiceURL,busID]];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       
                                                       // in case we want to know the response status code
                                                       //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                       
                                                       if (error != nil)
                                                       {
                                                           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                           {
                                                               // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                               // then your Info.plist has not been properly configured to match the target server.
                                                               //
                                                               abort();
                                                           }
                                                       }
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           
                                                          self.busStop.estimates = [self parseInfoJsonResponse:data];
                                                           [Utilities logObject:response];
                                                           
                                                           NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                           [Utilities logString:body];
                                                        
                                                           
                                                           // call our completion handler to tell our client that our icon is ready for display
                                                           if (self.completionHandler != nil)
                                                           {
                                                               self.completionHandler();
                                                           }
                                                       }];
                                                   }];
    
    [self.sessionTask resume];
}

// -------------------------------------------------------------------------------
//	cancelDownload
// -------------------------------------------------------------------------------
- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}
@end
