//
//  BusStopsViewController.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//
#import "BusStopsViewController.h"
#import "BusStopTableViewCell.h"
#import "BusStopsService.h"
#import "BusStop.h"
#import "NotificationKeys.h"
#import "JsonKeys.h"
#import "MapDownloader.h"
#import "BusStopInfoDownloader.h"
#import "Estimate.h"
static NSString *CellIdentifier = @"BusStopCell";

@interface BusStopsViewController ()
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSMutableDictionary *busStopInfoDownloadsInProgress;


@end

@implementation BusStopsViewController



-(void) getBusStops{
    [[BusStopsService sharedInstance] getBusStops];

}
-(void) initRefreshControl{
    
    // Initialize the refresh control.
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getBusStops)
                  forControlEvents:UIControlEventValueChanged];
    [self.tblBusStops addSubview:refreshControl];
    
}

-(void) initSearchController{
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.busStops count]];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tblBusStops.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

@synthesize tblBusStops,busStops,searchController,searchResults,refreshControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    _busStopInfoDownloadsInProgress = [NSMutableDictionary dictionary];

    [self initSearchController];
    [self initRefreshControl];
    [self getBusStops];

}




-(void) viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(busStopListLoaded:) name:BusStopListLoadedKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(busStopListLoadingFailed) name:BusStopListLoadingFailedKey object:nil];

}

-(void) viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)busStopListLoaded:(NSNotification *)notification {

    [self.refreshControl endRefreshing];
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo !=nil && [userInfo objectForKey:BusStops] !=nil) {
        busStops=[userInfo objectForKey:BusStops];

    }
    else{

        if (busStops) {
            [busStops removeAllObjects];
        }
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)busStopListLoadingFailed{
    

    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}
-(void) reloadData:(NSIndexPath*) indexPath{
    [tblBusStops reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void) reloadData{
    [tblBusStops reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
   
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if (self.searchController.active) {
         return [searchResults count];

     }
    else{
        return [busStops count];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusStopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BusStop *busStop;
    
    if (self.searchController.active) {
        busStop = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        busStop = [self.busStops objectAtIndex:indexPath.row];
    }
    // Only load cached images; defer new downloads until scrolling ends
    if (!busStop.map)
    {

        [self startIconDownload:busStop forIndexPath:indexPath];
        // if a download is deferred or in progress, return a placeholder image
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        cell.imageView.image = busStop.map;
    }
    
    if ([busStop.timeToArraive isEqualToString:@""])
    {

            [self startRealBusStopInfoDownload:busStop forIndexPath:indexPath];

            cell.timeLabel.text=@"N/A";
    }
    else
    {
        cell.timeLabel.text=busStop.timeToArraive;

    }
    
    [cell.nameLabel setText:[NSString stringWithFormat:@"%@ - %@", busStop.busId,busStop.title]];
    [cell.idLabel setText:busStop.busId];
  
    return cell;
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated{
    
    
    NSLog(@"scroll");
}



#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    

    [self updateFilteredContentForBusStopTitle:searchString];
    
    [self.tblBusStops reloadData];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForBusStopTitle:(NSString *)busStopTitle {
    
    // Update the filtered array based on the search text and scope.
    if ((busStopTitle == nil) || [busStopTitle length] == 0) {
        // If there is no search string and the scope is "All".
        self.searchResults = [self.busStops mutableCopy];
        return;
    }
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for Movies whose title matches searchText; add items that match to the filtered array.
     */
    for (BusStop *busStop in self.busStops) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange productNameRange = NSMakeRange(0, busStop.title.length);
        NSRange foundRange = [busStop.title rangeOfString:busStopTitle options:searchOptions range:productNameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:busStop];
        }

    }
}



#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(BusStop *)busStop forIndexPath:(NSIndexPath *)indexPath
{
    MapDownloader *mapDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (mapDownloader == nil)
    {
        mapDownloader = [[MapDownloader alloc] init];
        mapDownloader.busStop = busStop;
        [mapDownloader setCompletionHandler:^{
            
            BusStopTableViewCell *cell = [self.tblBusStops cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = busStop.map;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = mapDownloader;
        [mapDownloader startDownload];
    }
}


// -------------------------------------------------------------------------------
//	startRealBusStopInfoDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startRealBusStopInfoDownload:(BusStop *)busStop forIndexPath:(NSIndexPath *)indexPath
{
    BusStopInfoDownloader *busStopInfoDownloader = (self.busStopInfoDownloadsInProgress)[indexPath];
    if (busStopInfoDownloader == nil)
    {
        busStopInfoDownloader = [[BusStopInfoDownloader alloc] init];
        busStopInfoDownloader.busStop = busStop;
        [busStopInfoDownloader setCompletionHandler:^{
            if (busStop.estimates ) {
                
                if ([busStop.estimates count]>1) {
                    
                    NSArray *sortedArray;
                    sortedArray = [busStop.estimates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                        
                        NSNumber *first = [(Estimate*)a estimate];
                        NSNumber *second = [(Estimate*)b estimate];
                        return [first compare:second];
                    }];
                    
                    if (sortedArray&& [sortedArray count]>0) {
                        busStop.timeToArraive=[NSString stringWithFormat:@"[%@] %ld min",[(Estimate*)[sortedArray objectAtIndex:0] line],[[(Estimate*)[sortedArray objectAtIndex:0] estimate] longValue]];
                    }
                }
                else if ([busStop.estimates count]==1){
                           busStop.timeToArraive=[NSString stringWithFormat:@"[%@] %ld min",[(Estimate*)[busStop.estimates objectAtIndex:0] line],[[(Estimate*)[busStop.estimates objectAtIndex:0] estimate] longValue]];
                }
            
            }
            
            
            BusStopTableViewCell *cell = [self.tblBusStops cellForRowAtIndexPath:indexPath];
            
            cell.timeLabel.text=busStop.timeToArraive;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.busStopInfoDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.busStopInfoDownloadsInProgress)[indexPath] = busStopInfoDownloader;
        [busStopInfoDownloader startDownload:[busStop.busId longLongValue]];
    }
}

// -------------------------------------------------------------------------------
//	terminateAllDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

// -------------------------------------------------------------------------------
//	terminateAllBusStopInfoDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllBusStopInfoDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.busStopInfoDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.busStopInfoDownloadsInProgress removeAllObjects];
}


// -------------------------------------------------------------------------------
//	dealloc
//  If this view controller is going away, we need to cancel all outstanding downloads.
// -------------------------------------------------------------------------------
- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
    [self terminateAllBusStopInfoDownloads];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self terminateAllDownloads];
    [self terminateAllBusStopInfoDownloads];
    
    // Dispose of any resources that can be recreated.
}


@end
