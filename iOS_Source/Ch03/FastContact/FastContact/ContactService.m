//
//  ContactService.m
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ContactService.h"
#import "ContactRecord.h"

@implementation ContactService

+ (void)contactWithRecord:(ContactRecord *)record
{
    ABMultiValueRef multiValue = ABRecordCopyValue(record.person, record.propertyID);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue, record.multiValueIdentifier);
    NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    CFRelease(multiValue);
    
    NSString *scheme;
    if (record.propertyID == kABPersonPhoneProperty) {
        NSString *phoneNumber = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        scheme = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    } else {
        scheme = [NSString stringWithFormat:@"mailto:%@", value];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
}

@end
