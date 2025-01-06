//
//  DetailViewController.m
//  PhotoLibrary
//
//  Created by Ryosuke Sasaki on 2013/07/28.
//  Copyright (c) 2013年 saryou.jp. All rights reserved.
//

#import "DetailViewController.h"
#import "ZoomableImageView.h"
#import <Social/Social.h>

@interface DetailViewController () <UIActionSheetDelegate>
@property(weak, nonatomic) IBOutlet ZoomableImageView *imageView;
@property(assign, nonatomic) NSInteger twitterButtonIndex;
@property(assign, nonatomic) NSInteger facebookButtonIndex;
@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.image = [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetRepresentation *representation = [self.asset defaultRepresentation];
        CGImageRef imageRef = [representation fullResolutionImage];
        UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
        UIImage *image = [UIImage imageWithCGImage:imageRef
                                             scale:[[UIScreen mainScreen] scale]
                                       orientation:orientation];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)setBarsHidden:(BOOL)hidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden
                                            withAnimation:UIStatusBarAnimationFade];
    
    if (!hidden) {
        self.navigationController.navigationBarHidden = hidden;
        self.navigationController.toolbarHidden = hidden;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.alpha = hidden ? 0 : 1;
        self.navigationController.toolbar.alpha = hidden ? 0 : 1;
    } completion:^(BOOL finished) {
        self.navigationController.navigationBarHidden = hidden;
        self.navigationController.toolbarHidden = hidden;
    }];
}

- (IBAction)scrollViewTapped:(id)sender
{
    [self setBarsHidden:!self.navigationController.navigationBarHidden];
}

- (IBAction)performShareButtonAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.title = @"Share to Social";
    
    self.twitterButtonIndex = [actionSheet addButtonWithTitle:@"Twitter"];
    self.facebookButtonIndex = [actionSheet addButtonWithTitle:@"Facebook"];
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)shareWithServiceType:(NSString *)serviceType
{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [controller addImage:self.imageView.image];
    [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
        
    }];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    if (buttonIndex == self.twitterButtonIndex) {
        [self shareWithServiceType:SLServiceTypeTwitter];
    } else if (buttonIndex == self.facebookButtonIndex) {
        [self shareWithServiceType:SLServiceTypeFacebook];
    }
}

@end
