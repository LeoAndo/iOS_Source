//
//  DateField.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "DateField.h"

@interface DateField()
@property(strong, nonatomic) UIDatePicker *picker;
@property(strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation DateField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    picker.maximumDate = [NSDate date];
    _picker = picker;
    self.inputView = picker;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    _formatter = formatter;
    
    [picker addObserver:self forKeyPath:@"date" options:NSKeyValueObservingOptionNew context:nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    components.calendar = calendar;
    picker.date = [components date];
}

- (void)dealloc
{
    [_picker removeObserver:self forKeyPath:@"date"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.text = [self.formatter stringFromDate:self.date];
}

- (void)pickerValueChanged:(id)sender
{
    self.text = [self.formatter stringFromDate:self.date];
}

- (NSDate *)date
{
    return self.picker.date;
}

- (void)setDate:(NSDate *)date
{
    self.picker.date = date;
}

@end
