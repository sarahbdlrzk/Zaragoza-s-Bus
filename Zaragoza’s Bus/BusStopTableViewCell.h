//
//  BusStopTableViewCell.h
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BusStopTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *idLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end
