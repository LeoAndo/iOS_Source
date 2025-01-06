//
//  ViewController.m
//  FilterCamera
//
//  Created by Yoshitaka Yamashita on 2013/11/03.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"
#import "CameraManager.h"


@interface ViewController ()

@property (strong, nonatomic) CameraManager *cameraManager;
@property (weak, nonatomic) IBOutlet GPUImageView *cameraView;

@end

@implementation ViewController

#pragma mark - View LifeCycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        // カメラ管理クラスを初期化
        _cameraManager = [[CameraManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.cameraManager startCamera:(GPUImageView *)self.cameraView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ファインダー画面をViewいっぱいに広げる
    self.cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
}

#pragma mark - IBAction

// シャッターボタン押下時
- (IBAction)performShutterButtonAction:(UIBarButtonItem *)sender
{
    [self.cameraManager takePhoto];
}

// カメラ切替ボタン押下時
- (IBAction)performSwitchCameraButtonAction:(UIButton *)sender
{
    // カメラの切替
    [self.cameraManager switchCameraPosition:self.cameraView];
}

// 戻るボタン押下時
- (IBAction)performPreviousButtonAction:(UIBarButtonItem *)sender
{
    [self.cameraManager setPreviousFilter:self.cameraView];
}

// 次へボタン押下時
- (IBAction)performNextButtonAction:(UIBarButtonItem *)sender
{
    [self.cameraManager setNextFilter:self.cameraView];
}

@end
