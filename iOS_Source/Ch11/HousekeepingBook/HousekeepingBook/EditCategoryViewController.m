//
//  EditCategoryViewController.m
//  HousekeepingBook
//
//  Created by Ryosuke Sasaki on 2013/10/12.
//  Copyright (c) 2013年 Ryosuke Sasaki. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "ItemCategory.h"
#import "DataManager.h"

@interface EditCategoryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@end

@implementation EditCategoryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.itemCategory) {
        self.title = @"カテゴリを編集";
    } else {
        self.title = @"カテゴリを追加";
        
        self.itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ItemCategory"
                                                          inManagedObjectContext:[[DataManager sharedManager] managedObjectContext]];
        self.itemCategory.color = [UIColor blackColor];
    }
    
    self.nameField.text = self.itemCategory.name;
    
    CGFloat r, g, b, a;
    [self.itemCategory.color getRed:&r green:&g blue:&b alpha:&a];
    self.redSlider.value = r;
    self.greenSlider.value = g;
    self.blueSlider.value = b;
    
    self.colorView.backgroundColor = self.itemCategory.color;
}

- (void)reloadColorView
{
    self.colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value
                                                     green:self.greenSlider.value
                                                      blue:self.blueSlider.value
                                                     alpha:1];
}

- (IBAction)redSliderValueChanged:(id)sender
{
    [self reloadColorView];
}

- (IBAction)greenSliderValueChanged:(id)sender
{
    [self reloadColorView];
}

- (IBAction)blueSliderValueChanged:(id)sender
{
    [self reloadColorView];
}

- (IBAction)performCancelButtonAction:(id)sender
{
    if (self.itemCategory.isInserted)
        [[[DataManager sharedManager] managedObjectContext] deleteObject:self.itemCategory];
    else
        [[[DataManager sharedManager] managedObjectContext] refreshObject:self.itemCategory mergeChanges:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)performSaveButtonAction:(id)sender
{
    self.itemCategory.name = self.nameField.text;
    self.itemCategory.color = self.colorView.backgroundColor;
    
    [[[DataManager sharedManager] managedObjectContext] save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
