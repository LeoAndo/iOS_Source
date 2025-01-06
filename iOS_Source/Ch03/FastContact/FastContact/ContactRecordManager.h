//
//  ContactRecord.h
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactRecordManager : NSObject

@property(readonly, nonatomic) NSMutableArray *records;
@property(readonly, nonatomic) ABAddressBookRef addressBook;

+ (instancetype)sharedManager;
- (BOOL)save;

@end
