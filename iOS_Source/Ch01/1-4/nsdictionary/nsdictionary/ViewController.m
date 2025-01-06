//
//  ViewController.m
//  nsdictionary
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
    
    // NSDictionaryの作成
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2"};
    
    // 要素数の表示
    NSLog(@"要素数は %d", [dictionary count]);
    
    // 要素の取り出し
    NSLog(@"key1の要素は %@", dictionary[@"key1"]);
    
    // 可変連想配列の作成
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    
    // 要素の追加
    mutableDictionary[@"key3"] = @"value3";
    
    // 要素数の表示
    NSLog(@"要素数は %d", [mutableDictionary count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
