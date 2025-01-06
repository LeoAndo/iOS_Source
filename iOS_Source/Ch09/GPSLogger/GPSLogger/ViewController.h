//
//  ViewController.h
//  GPSLogger
//
//  Created by Yoshitaka Yamashita on 2013/09/04.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<
    MKMapViewDelegate,
    CLLocationManagerDelegate,
    UIGestureRecognizerDelegate
>

@end
