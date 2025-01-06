//
//  EditItemViewController.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "EditItemViewController.h"
#import "CategoriesViewController.h"
#import "Item.h"
#import "ItemCategory.h"
#import "DataManager.h"
#import "DateField.h"

@interface EditItemViewController () <CategoriesViewControllerDelegate>
@property (weak, nonatomic) IBOutlet DateField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *signControl;
@property (weak, nonatomic) IBOutlet UITextField *expenseField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@end

@implementation EditItemViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    if (self.title.length == 0) {
        if (self.item) {
            self.title = @"項目を編集";
        } else {
            self.title = @"項目を追加";
            
            self.item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                      inManagedObjectContext:[[DataManager sharedManager] managedObjectContext]];
        }
        
        self.nameField.text = self.item.name;
        self.noteField.text = self.item.note;
        NSInteger expense = [self.item.expense integerValue];
        self.signControl.selectedSegmentIndex = expense >= 0 ? 1 : 0;
        self.expenseField.text = expense == 0 ? @"" : [NSString stringWithFormat:@"%ld", (long)ABS(expense)];
        self.categoryNameLabel.text = self.item.category.name;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = keyboardFrame.size.height;
    self.tableView.contentInset = inset;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 0;
    self.tableView.contentInset = inset;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    CategoriesViewController *controller = (id)navigationController.topViewController;
    controller.delegate = self;
}

- (IBAction)performCancelButtonAction:(id)sender
{
    if (self.item.isInserted)
        [[[DataManager sharedManager] managedObjectContext] deleteObject:self.item];
    else
        [[[DataManager sharedManager] managedObjectContext] refreshObject:self.item mergeChanges:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)performSaveButtonAction:(id)sender
{
    NSMutableArray *errors = [NSMutableArray array];
    
    if ([self.expenseField.text integerValue] == 0)
        [errors addObject:@"収支が入力されていません。"];
    if (!self.item.category)
        [errors addObject:@"カテゴリが選択されていません。"];
    
    if ([errors count] > 0) {
        [[[UIAlertView alloc] initWithTitle:@"エラー"
                                    message:[errors componentsJoinedByString:@"\n"]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    
    self.item.date = self.dateField.date;
    self.item.name = self.nameField.text;
    self.item.note = self.noteField.text;
    
    NSInteger value = [self.expenseField.text integerValue];
    if (self.signControl.selectedSegmentIndex == 0)
        value *= -1;
    self.item.expense = @(value);
    
    [[[DataManager sharedManager] managedObjectContext] save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - CategoriesViewControllerDelegate
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (void)categoriesViewControllerDidCancel:(CategoriesViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)categoriesViewController:(CategoriesViewController *)controller didSelectCategory:(ItemCategory *)category
{
    self.item.category = category;
    self.categoryNameLabel.text = self.item.category.name;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
