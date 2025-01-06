//
//  ViewController.m
//  scrollview
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface StripeView : UIView

@end

@implementation StripeView

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width / 20;
    CGFloat height = rect.size.height;
    for (NSInteger i = 0; i < 20; i++) {
        [[UIColor colorWithWhite:(i % 2 == 0) ? 1 : 0 alpha:1] setFill];
        CGRect rect = CGRectMake(width * i, 0, width, height);
        UIRectFill(rect);
    }
}

@end

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) StripeView *stripeView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    StripeView *stripeView = [[StripeView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    self.stripeView = stripeView;
    
    [self.scrollView addSubview:stripeView];
    self.scrollView.contentSize = stripeView.frame.size;
    self.scrollView.minimumZoomScale = 0.5f;
    self.scrollView.maximumZoomScale = 4.0f;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.stripeView;
}

@end