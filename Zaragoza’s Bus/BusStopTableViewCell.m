//
//  BusStopTableViewCell.m
//  Zaragoza’s Bus
//
//  Created by Sarah Abdelrazak on 8/10/16.
//  Copyright © 2016 Sarah. All rights reserved.
//
#import "BusStopTableViewCell.h"

@implementation BusStopTableViewCell
@synthesize nameLabel;
@synthesize idLabel;
@synthesize timeLabel;
@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
