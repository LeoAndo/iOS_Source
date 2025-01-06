//
//  ItemCell.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ItemCell.h"
#import "Item.h"
#import "ItemCategory.h"

@interface ItemCell()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end

@implementation ItemCell

- (void)setItem:(Item *)item
{
    _item = item;
    
    NSInteger expense = [item.expense integerValue];
    self.dateLabel.text = [[ItemCell formatter] stringFromDate:item.date];
    self.expenseLabel.textColor = expense >= 0 ? [UIColor redColor] : [UIColor blueColor];
    self.expenseLabel.text = [NSString stringWithFormat:@"%ld", (long)-expense];
    self.nameLabel.text = item.name;
    self.categoryLabel.text = item.category.name;
    self.colorView.backgroundColor = item.category.color;
}

+ (NSDateFormatter *)formatter
{
    static id formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    });
    return formatter;
}

@end
