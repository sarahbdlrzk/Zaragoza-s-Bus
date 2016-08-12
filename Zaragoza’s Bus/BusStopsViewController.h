//
//  BusStopsViewController.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BusStopsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results
@property (weak, nonatomic) IBOutlet UITableView *tblBusStops;
@property (strong, nonatomic) NSMutableArray *busStops;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

