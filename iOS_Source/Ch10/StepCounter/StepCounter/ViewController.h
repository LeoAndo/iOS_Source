//
//  ViewController.h
//  StepCounter
//
//  Created by Yoshitaka Yamashita on 2013/11/02.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "MotionManager.h"

@interface ViewController : UIViewController
<
    UITableViewDataSource, UITableViewDelegate,
    MotionManagerDelegate
>
@end
