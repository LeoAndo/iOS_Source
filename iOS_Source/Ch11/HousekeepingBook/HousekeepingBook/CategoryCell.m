//
//  CategoryCell.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "CategoryCell.h"
#import "ItemCategory.h"

@interface CategoryCell()
@property(weak, nonatomic) UIView *colorView;
@end

@implementation CategoryCell

- (void)awakeFromNib
{
    UIView *colorView = [[UIView alloc] init];
    [self.contentView addSubview:colorView];
    _colorView = colorView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect colorViewFrame = CGRectMake(2, 2, 40, 40);
    self.colorView.frame = colorViewFrame;
    
    CGRect textLabelFraem = self.textLabel.frame;
    textLabelFraem.origin.x += CGRectGetMaxX(colorViewFrame);
    textLabelFraem.size.width -= CGRectGetMaxX(colorViewFrame);
    self.textLabel.frame = textLabelFraem;
}

- (void)setItemCategory:(ItemCategory *)itemCategory
{
    _itemCategory = itemCategory;
    
    self.textLabel.text = itemCategory.name;
    self.colorView.backgroundColor = itemCategory.color;
}

@end
