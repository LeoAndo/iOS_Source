//
//  ViewController.m
//  openurl
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
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performCallButtonAction:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"tel:xxxxxxxxxxx"]; // 注: xxxxxxxxxxxは適宜自分の電話番号等に置き換えてください
    if ([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
}

@end
