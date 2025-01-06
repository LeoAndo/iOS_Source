//
//  DataManager.h
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/09.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

@end
