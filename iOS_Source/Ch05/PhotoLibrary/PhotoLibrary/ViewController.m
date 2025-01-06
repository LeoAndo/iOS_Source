//
//  ViewController.m
//  PhotoLibrary
//
//  Created by Ryosuke Sasaki on 2013/07/28.
//  Copyright (c) 2013年 saryou.jp. All rights reserved.
//

#import "ViewController.h"
#import "PhotosViewController.h"

@interface ViewController ()
@property(strong, nonatomic) ALAssetsLibrary *library;
@property(strong, nonatomic) NSArray *groups;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.library = library;
    
    NSMutableArray *groups = [NSMutableArray array];
    self.groups = groups;
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               if (group) {
                                   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[groups count]
                                                                               inSection:0];
                                   [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                   [groups addObject:group];
                                   [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                                         withRowAnimation:UITableViewRowAnimationFade];
                               }
                           } failureBlock:^(NSError *error) {
                               
                           }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ALAssetsGroup *group = self.groups[indexPath.row];
    [segue.destinationViewController setGroup:group];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    
    ALAssetsGroup *group = self.groups[indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:[group posterImage]];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [group numberOfAssets]];
    
    return cell;
}

@end
