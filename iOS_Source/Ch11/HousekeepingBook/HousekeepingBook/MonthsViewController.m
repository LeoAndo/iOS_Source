//
//  MonthsViewController.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/14.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "MonthsViewController.h"
#import "DataManager.h"
#import "Item.h"
#import "ItemsViewController.h"

@interface MonthsViewController ()
@property(strong, nonatomic) NSCalendar *calendar;
@property(assign, nonatomic) NSInteger yearForNow;
@property(assign, nonatomic) NSInteger monthForNow;
@property(assign, nonatomic) NSInteger yearForFirstDate;
@property(assign, nonatomic) NSInteger monthForFirstDate;
@end

@implementation MonthsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.calendar = calendar;
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *nowComponents = [calendar components:units fromDate:now];
    
    self.yearForNow = nowComponents.year;
    self.monthForNow = nowComponents.month;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    request.sortDescriptors = @[descriptor];
    
    NSArray *results = [[[DataManager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
    if ([results count] > 0) {
        NSDate *firstDate = [results[0] date];
        NSDateComponents *firstDateComponents = [calendar components:units fromDate:firstDate];
        self.yearForFirstDate = firstDateComponents.year;
        self.monthForFirstDate = firstDateComponents.month;
    } else {
        self.yearForFirstDate = self.yearForNow;
        self.monthForFirstDate = self.monthForNow;
    }
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        NSInteger year, month;
        [self getYear:&year month:&month atIndexPath:indexPath];
        
        ItemsViewController *controller = segue.destinationViewController;
        controller.year = year;
        controller.month = month;
        controller.itemCategory = self.itemCategory;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.yearForNow - self.yearForFirstDate) * 12 + (self.monthForNow - self.monthForFirstDate) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger year, month;
    [self getYear:&year month:&month atIndexPath:indexPath];
    
    NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    
    NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
    firstComponents.calendar = self.calendar;
    firstComponents.year = year;
    firstComponents.month = month;
    firstComponents.day = 1;
    NSDate *firstDate = [firstComponents date];
    
    NSDateComponents *lastComponents = [firstComponents copy];
    lastComponents.month = month + 1;
    NSDate *lastDate = [lastComponents date];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"date >= %@ and date < %@", firstDate, lastDate];
    if (self.itemCategory) {
        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category = %@", self.itemCategory];
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, categoryPredicate]];
    }
    [request setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    NSInteger expense = 0;
    for (Item *item in results) {
        expense += [item.expense integerValue];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d/%d", (int)year, (int)month];
    cell.detailTextLabel.textColor = expense >= 0 ? [UIColor redColor] : [UIColor blueColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)-expense];
    
    return cell;
}

- (void)getYear:(NSInteger *)year month:(NSInteger *)month atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger y = self.yearForNow - indexPath.row / 12;
    NSInteger m = self.monthForNow - indexPath.row % 12;
    if (m >= 12) {
        y += 1;
        m -= 12;
    }
    *year = y;
    *month = m;
}

@end
