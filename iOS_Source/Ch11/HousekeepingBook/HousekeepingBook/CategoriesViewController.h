//
//  CategoriesViewController.h
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoriesViewControllerDelegate;
@class ItemCategory;

@interface CategoriesViewController : UITableViewController
@property(weak, nonatomic) id<CategoriesViewControllerDelegate> delegate;
@end

@protocol CategoriesViewControllerDelegate <NSObject>
- (void)categoriesViewControllerDidCancel:(CategoriesViewController *)controller;
- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategory:(ItemCategory *)category;
@end