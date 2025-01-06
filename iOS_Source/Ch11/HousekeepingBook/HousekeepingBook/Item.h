//
//  Item.h
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemCategory;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * expense;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) ItemCategory *category;

@end
