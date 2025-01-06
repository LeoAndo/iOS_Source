//
//  ItemsViewController.h
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemCategory;

@interface ItemsViewController : UITableViewController
@property(assign, nonatomic) NSInteger year;
@property(assign, nonatomic) NSInteger month;
@property(strong, nonatomic) ItemCategory *itemCategory;
@end
