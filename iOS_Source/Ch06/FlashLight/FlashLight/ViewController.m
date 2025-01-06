//
//  ViewController.m
//  FlashLight
//
//  Created by Yoshitaka Yamashita on 2013/08/12.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *lightSwitch;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
- (IBAction)performLightSwitchAction:(UISwitch *)sender;
- (IBAction)performBrightnessSliderAction:(UISlider *)sender;

@end

@implementation ViewController

//----------------------------------------
#pragma mark - View LifeCycle
//----------------------------------------

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

// ファーストレスポンダになれることを返す
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

// Viewが表示されたタイミング
- (void)viewDidAppear:(BOOL)animated
{
    // ファーストレスポンダとして設定
    [self becomeFirstResponder];
}

//----------------------------------------
#pragma mark - UIEvent
//----------------------------------------

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // シェイクジェスチャを認識したとき
    if (motion == UIEventSubtypeMotionShake) {
        // スイッチのON/OFFを切り替え
        [self.lightSwitch setOn:!self.lightSwitch.isOn animated:YES];
        
        // ライトの制御
        [self setLight];
    }
}

//----------------------------------------
#pragma mark - IBAction
//----------------------------------------

// UISwitchイベント
- (IBAction)performBrightnessSliderAction:(UISlider *)sender
{
    // ライトの制御
    [self setLight];
}

// UISliderイベント
- (IBAction)performLightSwitchAction:(UISwitch *)sender
{
    // ライトの制御
    [self setLight];
}

//----------------------------------------
#pragma mark - Control Light
//----------------------------------------

// ライトの制御
- (void)setLight
{
    NSError *error = nil;
    
    // ビデオデバイスを取得
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // 各コントローラから値を取得
    BOOL isOn = self.lightSwitch.isOn;
    float level = self.brightnessSlider.value;

    // トーチを持ったデバイスが正しく取得できていれば
    if(device && device.hasTorch) {
        
        // デバイスをロック
        [device lockForConfiguration:&error];
        
        // 明るさが0より大きく、スイッチがONになっていれば
        if(level > 0.0f && isOn) {
            // トーチの明るさを設定
            [device setTorchModeOnWithLevel:level error:&error];
        }
        else {
            // トーチをオフに
            device.torchMode = AVCaptureTorchModeOff;
        }
        
        // ロックの解除
        [device unlockForConfiguration];
    }
}


@end
