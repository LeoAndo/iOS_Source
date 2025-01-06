//
//  ViewController.m
//  nsarray
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 配列の作成
    NSArray *array = @[@"A", @"B", @"C"];
    
    // 配列の要素数を表示
    NSLog(@"length: %d", [array count]);
    
    // 配列の最初のオブジェクトを表示
    NSLog(@"first object: %@", array[0]);
    
    // 可変配列の作成
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    // 可変配列の最後にオブジェクトを追加
    [mutableArray addObject:@"D"];
    
    // 可変配列の要素数を表示
    NSLog(@"length: %d", [mutableArray count]);
    
    // 配列の要素を書き出す
    for (NSString *string in mutableArray) {
        NSLog(@"element: %@", string);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
