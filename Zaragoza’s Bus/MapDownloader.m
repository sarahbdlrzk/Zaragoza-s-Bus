//
//  MapDownloader.m
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


#import "MapDownloader.h"
#import "BusStop.h"
#define kAppIconSize 200

@interface MapDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation MapDownloader
@synthesize busStop;
// -------------------------------------------------------------------------------
//	startDownload
// -------------------------------------------------------------------------------
- (void)startDownload
{
    NSString *url=[ NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%ld,%ld&zoom=15&size=200x200&sensor=true", [busStop.lat longValue],[busStop.lon longValue]];
    
    
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
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
                                                           
                                                           // Set appIcon and clear temporary data/image
                                                           UIImage *image = [[UIImage alloc] initWithData:data];
                                                           
                                                           if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
                                                           {
                                                               CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                                                               UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                                                               CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                                               [image drawInRect:imageRect];
                                                               self.busStop.map = UIGraphicsGetImageFromCurrentImageContext();
                                                               UIGraphicsEndImageContext();
                                                           }
                                                           else
                                                           {
                                                               self.busStop.map = image;
                                                           }
                                                           
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
