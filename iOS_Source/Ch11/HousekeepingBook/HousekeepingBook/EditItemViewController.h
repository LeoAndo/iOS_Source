//
//  EditItemViewController.h
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface EditItemViewController : UITableViewController
@property(strong, nonatomic) Item *item;
@end
