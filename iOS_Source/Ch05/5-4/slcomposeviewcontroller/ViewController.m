//
//  ViewController.m
//  slcomposeviewcontroller
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end

@implementation ViewController

- (IBAction)post:(id)sender
{
    NSString *serviceType;
    if (self.segmentedControl.selectedSegmentIndex == 0)
        serviceType = SLServiceTypeTwitter;
    else
        serviceType = SLServiceTypeFacebook;
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone)
            NSLog(@"投稿完了！");
        else
            NSLog(@"キャンセル！");
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

@end