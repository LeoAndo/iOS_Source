//
//  ContactService.h
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactRecord;

@interface ContactService : NSObject
+ (void)contactWithRecord:(ContactRecord *)record;
@end
