//
//  PhotosViewController.m
//  PhotoLibrary
//
//  Created by Ryosuke Sasaki on 2013/07/28.
//  Copyright (c) 2013年 saryou.jp. All rights reserved.
//

#import "PhotosViewController.h"
#import "DetailViewController.h"

@interface PhotosViewController ()
@property(strong, nonatomic) NSArray *assets;
@end

@implementation PhotosViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.assets) {
        NSMutableArray *assets = [NSMutableArray array];
        self.assets = assets;
        [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result)
                [assets insertObject:result atIndex:0];
        }];
        [self.collectionView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *controller = segue.destinationViewController;
    NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
    controller.asset = self.assets[indexPath.item];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource
#pragma mark -
////////////////////////////////////////////////////////////////////////////////

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                     forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[indexPath.item];
    UIImageView *imageView = (id)[cell.contentView viewWithTag:10];
    imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
    return cell;
}

@end