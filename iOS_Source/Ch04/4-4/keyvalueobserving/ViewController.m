//
//  ViewController.m
//  keyvalueobserving
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(weak, nonatomic) UILabel *label1;
@property(weak, nonatomic) UILabel *label2;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 30, 320, 30)];
    [self.view addSubview:slider];
    // スライダーを変更した時のアクションを設定
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 30)];
    [self.view addSubview:label1];
    self.label1 = label1;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 30)];
    [self.view addSubview:label2];
    self.label2 = label2;
    
    // label1 の text が変更された時に通知する
    [label1 addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    self.label1.text = [NSString stringWithFormat:@"%f", slider.value];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.label2.text = self.label1.text;
}

@end