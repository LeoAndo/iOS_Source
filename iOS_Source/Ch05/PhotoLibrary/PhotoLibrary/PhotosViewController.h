//
//  PhotosViewController.h
//  PhotoLibrary
//
//  Created by Ryosuke Sasaki on 2013/07/28.
//  Copyright (c) 2013年 saryou.jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UICollectionViewController
@property(strong, nonatomic) ALAssetsGroup *group;
@end
