//
//  ContactRecord.m
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ContactRecord.h"
#import "ContactRecordManager.h"

static NSString *const kEncodeKeyRecordID = @"RecordID";
static NSString *const kEncodeKeyPropertyID = @"PropertyID";
static NSString *const kEncodeKeyMultiValueIdentifier = @"MultiValueIdentifier";

@interface ContactRecord()
@property(assign, nonatomic) ABRecordID recordID;
@end

@implementation ContactRecord

- (id)initWithPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    self = [super init];
    if (self) {
        _recordID = ABRecordGetRecordID(person);
        _propertyID = property;
        _multiValueIdentifier = identifier;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _recordID = [aDecoder decodeInt32ForKey:kEncodeKeyRecordID];
        _propertyID = [aDecoder decodeInt32ForKey:kEncodeKeyPropertyID];
        _multiValueIdentifier = [aDecoder decodeInt32ForKey:kEncodeKeyMultiValueIdentifier];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt32:_recordID forKey:kEncodeKeyRecordID];
    [aCoder encodeInt32:_propertyID forKey:kEncodeKeyPropertyID];
    [aCoder encodeInt32:_multiValueIdentifier forKey:kEncodeKeyMultiValueIdentifier];
}

- (ABRecordRef)person
{
    ABAddressBookRef addressBook = [[ContactRecordManager sharedManager] addressBook];
    return ABAddressBookGetPersonWithRecordID(addressBook, self.recordID);
}

@end
