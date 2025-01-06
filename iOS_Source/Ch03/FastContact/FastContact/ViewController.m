//
//  ViewController.m
//  FastContact
//
//  Created by Ryosuke Sasaki on 2013/03/02.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "ViewController.h"
#import "ContactRecord.h"
#import "ContactRecordManager.h"
#import "ContactService.h"

@interface ViewController () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ViewController

- (void)awakeFromNib
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performAddButtonAction:(id)sender
{
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.peoplePickerDelegate = self;
    controller.displayedProperties = @[@(kABPersonPhoneProperty), @(kABPersonEmailProperty)];
    [self presentViewController:controller animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ABPeoplePickerNavigationControllerDelegate
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    ContactRecord *record = [[ContactRecord alloc] initWithPerson:person
                                                         property:property
                                                       identifier:identifier];
    
    ContactRecordManager *manager = [ContactRecordManager sharedManager];
    [manager.records addObject:record];
    [manager save];
    
    [self.tableView reloadData];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ContactRecordManager sharedManager] records] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    ContactRecord *record = [[ContactRecordManager sharedManager] records][indexPath.row];
    ABRecordRef person = record.person;
    
    NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
    cell.textLabel.text = name;
    
    ABMultiValueRef multiValue = ABRecordCopyValue(person, record.propertyID);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue, record.multiValueIdentifier);
    NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    CFRelease(multiValue);
    cell.detailTextLabel.text = value;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ContactRecordManager *manager = [ContactRecordManager sharedManager];
        [manager.records removeObjectAtIndex:indexPath.row];
        [manager save];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    ContactRecordManager *manager = [ContactRecordManager sharedManager];
    NSMutableArray *records = manager.records;
    id object = records[sourceIndexPath.row];
    [records removeObjectAtIndex:sourceIndexPath.row];
    [records insertObject:object atIndex:destinationIndexPath.row];
    [manager save];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactRecord *record = [[ContactRecordManager sharedManager] records][indexPath.row];
    [ContactService contactWithRecord:record];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ContactRecord *record = [[ContactRecordManager sharedManager] records][indexPath.row];
    ABPersonViewController *controller = [[ABPersonViewController alloc] init];
    controller.displayedPerson = record.person;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
