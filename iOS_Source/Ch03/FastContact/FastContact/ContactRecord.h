//
//  ContactRecord.h
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactRecord : NSObject <NSCoding>

- (id)initWithPerson:(ABRecordRef)person
            property:(ABPropertyID)property
          identifier:(ABMultiValueIdentifier)identifier;

@property(readonly, nonatomic) ABRecordRef person;
@property(readonly, nonatomic) ABPropertyID propertyID;
@property(readonly, nonatomic) ABMultiValueIdentifier multiValueIdentifier;

@end
