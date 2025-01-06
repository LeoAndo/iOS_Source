//
//  NumberCell.h
//  collectionview
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberCell : UICollectionViewCell
@property(copy, nonatomic) NSNumber *number;
+ (CGSize)cellSizeWithNumber:(NSNumber *)number;
@end

