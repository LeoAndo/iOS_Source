//
//  CategoriesViewController.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "CategoriesViewController.h"
#import "DataManager.h"
#import "CategoryCell.h"
#import "ItemCategory.h"
#import "EditCategoryViewController.h"
#import "MonthsViewController.h"

@interface CategoriesViewController () <NSFetchedResultsControllerDelegate>
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation CategoriesViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSManagedObjectContext *context = [[DataManager sharedManager] managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ItemCategory"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
        
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
    if ([sender isKindOfClass:[CategoryCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        UINavigationController *navigationController = segue.destinationViewController;
        EditCategoryViewController *contoller = (id)[navigationController topViewController];
        contoller.itemCategory = category;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.delegate respondsToSelector:@selector(categoriesViewControllerDidCancel:)]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(performCancelButtonAction:)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)performCancelButtonAction:(id)sender
{
    [self.delegate categoriesViewControllerDidCancel:self];
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
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:category];
        [self.fetchedResultsController.managedObjectContext save:nil];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [category.items count] == 0;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(categoriesViewController:didSelectCategory:)]) {
        ItemCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.delegate categoriesViewController:self didSelectCategory:category];
    } else {
        MonthsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MonthsViewController"];
        controller.itemCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    }
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

- (void)configureCell:(CategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ItemCategory *itemCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.itemCategory = itemCategory;
}

@end
