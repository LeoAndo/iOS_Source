//
//  ViewController.m
//  steps
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
    
    // 歩数計に対応しているかどうか
    if([CMStepCounter isStepCountingAvailable])
    {
        // 歩数計のオブジェクト作成
        CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
        
        // 一日分のインターバル
        NSTimeInterval oneDayInterval = 24.0f * 60.0f * 60.0f;
        
        // 今日と24時間前のNSDateを作成
        NSDate *today = [NSDate date];
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-oneDayInterval];
        
        // 指定した範囲の歩数を取得
        [stepCounter queryStepCountStartingFrom:yesterday
                                             to:today
                                        toQueue:[NSOperationQueue mainQueue]
                                    withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                        if(!error) {
                                            NSLog(@"%ld steps", numberOfSteps);
                                        }
                                    }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

