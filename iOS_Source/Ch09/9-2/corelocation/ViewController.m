//
//  ViewController.m
//  corelocation
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 位置情報が通知されたとき
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 最新の位置情報を取り出す
    CLLocation *location = [locations lastObject];
    NSLog(@"%f, %f", location.coordinate.latitude, location.coordinate.longitude);
}
@end
