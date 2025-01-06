//
//  ViewController.m
//  simplecamera
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property(strong, nonatomic) AVCaptureSession *session;
@property(strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // カメラの設定
    [self configureCamera];
}

// カメラの設定
- (BOOL)configureCamera
{
    NSError *error;
    
    // セッションを作成
    if(self.session) {
        [self.session stopRunning];
        self.session = nil;
    }
    self.session = [[AVCaptureSession alloc] init];
    
    // 入力デバイス
    AVCaptureDevice *captureDevice = nil;
    NSArray *devices =  [AVCaptureDevice devices];
    
    // 背面カメラを見つける
    for(AVCaptureDevice *device in devices)
    {
        if(device.position == AVCaptureDevicePositionBack)
        {
            captureDevice = device;
        }
    }
    
    // カメラが見つからなかった場合
    if(captureDevice == nil) { return NO; }
    
    // デバイスからデバイス入力を得る
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    
    if(error) {
        // カメラの初期化に失敗
        return NO;
    }
    
    // 静止画出力を作成
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // プレビュー用レイヤ
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:previewLayer];
    
    // セッションの設定
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    [self.session addInput:deviceInput];
    [self.session addOutput:self.stillImageOutput];
    
    // セッション開始
    [self.session startRunning];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

// カメラボタン押下時
- (IBAction)performCameraButtonAction:(id)sender
{
    // コネクションの取得
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 静止画を撮影
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         // エラーの場合
         if(error) { return; }
         
         // バッファからJPEGフォーマットの画像を取得
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         // 画像のデータからUIImageを作成
         UIImage *image = [UIImage imageWithData:imageData];
         // カメラロールに画像を保存
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingImageWithError:contextInfo:), nil);
     }];
}

// カメラロール保存時に呼ばれるメソッド
- (void)image:(UIImage *)image didFinishSavingImageWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // エラーがあればメッセージ表示
    if(error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                            message:@"写真の保存に失敗しました"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
