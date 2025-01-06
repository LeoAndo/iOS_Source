//
//  ViewController.m
//  nsstring
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
    
    // NSStringオブジェクトの作成
    NSString *string = @"Hello world!";
    NSLog(@"%@", string);
    
    // NSStringのメソッド呼び出し
    NSLog(@"文字数は%d", [string length]);
    
    // NSMutableStringオブジェクトの作成
    NSMutableString *mutableString = [NSMutableString stringWithString:string];
    NSLog(@"%@", mutableString);
    
    // NSMutableStringの指定位置に文字列を挿入
    [mutableString insertString:@"iOS " atIndex:6];
    NSLog(@"%@", mutableString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
