//
//  ItemsViewController.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ItemsViewController.h"
#import "DataManager.h"
#import "ItemCell.h"
#import "Item.h"
#import "EditItemViewController.h"

@interface ItemsViewController () <NSFetchedResultsControllerDelegate>
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ItemsViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
        request.sortDescriptors = @[sortDescriptor];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *firstComponents = [[NSDateComponents alloc] init];
        firstComponents.calendar = calendar;
        firstComponents.year = self.year;
        firstComponents.month = self.month;
        firstComponents.day = 1;
        NSDate *firstDate = [firstComponents date];
        
        NSDateComponents *lastComponents = [firstComponents copy];
        lastComponents.month = self.month + 1;
        NSDate *lastDate = [lastComponents date];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"date >= %@ and date < %@", firstDate, lastDate];
        if (self.itemCategory) {
            NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category = %@", self.itemCategory];
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, categoryPredicate]];
        }
        [request setPredicate:predicate];

        NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                                  initWithFetchRequest:request
                                                  managedObjectContext:context
                                                  sectionNameKeyPath:nil
                                                  cacheName:nil];
        controller.delegate = self;
        [controller performFetch:nil];
        
        _fetchedResultsController = controller;
    }
    
    return _fetchedResultsController;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[ItemCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        UINavigationController *navigationController = segue.destinationViewController;
        EditItemViewController *controller = (id)[navigationController topViewController];
        controller.item = item;
    }
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections][section] objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:item];
        [self.fetchedResultsController.managedObjectContext save:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSFetchedResultsControllerDelegate
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(id)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(ItemCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.item = item;
}

@end
