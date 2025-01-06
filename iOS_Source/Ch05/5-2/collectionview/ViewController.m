//
//  ViewController.m
//  collectionview
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"
#import "NumberCell.h"

@interface ViewController () <UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[NumberCell class]
            forCellWithReuseIdentifier:@"cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NumberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    cell.number = @(indexPath.row + 1);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [NumberCell cellSizeWithNumber:@(indexPath.row + 1)];
}

@end