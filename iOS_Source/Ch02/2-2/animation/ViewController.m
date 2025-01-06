//
//  ViewController.m
//  animation
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
    
    // ビューを初期化する
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    // 背景色を赤にする
    redView.backgroundColor = [UIColor redColor];
    // 作成したビューを、ビューコントローラが管理するビューに追加する
    [self.view addSubview:redView];
    // アニメーションさせる
    [UIView animateWithDuration:3 animations:^{
        redView.frame = CGRectMake(200, 300, 50, 50);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
