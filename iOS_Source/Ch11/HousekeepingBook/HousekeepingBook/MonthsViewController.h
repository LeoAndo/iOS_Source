//
//  MonthsViewController.h
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/14.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemCategory;

@interface MonthsViewController : UITableViewController
@property(strong, nonatomic) ItemCategory *itemCategory;
@end
