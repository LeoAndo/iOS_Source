//
//  ContactRecord.m
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ContactRecordManager.h"

@interface ContactRecordManager()

@end

@implementation ContactRecordManager

+ (instancetype)sharedManager
{
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *records = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
        if (!records) {
            records = [NSMutableArray array];
        }
        
        _addressBook = ABAddressBookCreateWithOptions(nil, nil);
        _records = records;
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_addressBook);
}

- (NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *name = @"records.plist";
    return [path stringByAppendingPathComponent:name];
}

- (BOOL)save
{
    return [NSKeyedArchiver archiveRootObject:self.records toFile:[self filePath]];
}

@end
