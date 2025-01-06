//
//  CameraManager.m
//  FilterCamera
//
//  Created by Yoshitaka Yamashita on 2013/11/03.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "CameraManager.h"

@interface CameraManager()
// 静止画カメラ
@property(nonatomic, strong) GPUImageStillCamera *stillCamera;
// フィルタの配列
@property(nonatomic, strong) NSArray *filterArray;
// 現在のフィルタ
@property(nonatomic, strong) GPUImageFilter *currentFilter;
// フロントカメラフラグ
@property(readwrite) AVCaptureDevicePosition cameraPosition;
@end

@implementation CameraManager

- (id)init
{
    self = [super init];
    if (self) {
        _cameraPosition = AVCaptureDevicePositionFront;
    }
    
    // フィルタの初期化
    [self initializeFilter];
    
    return self;
}

#pragma mark - Camera

// カメラキャプチャのスタート
- (void)startCamera:(GPUImageView *)imageView
{
    // カメラのスタート
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto
                                                           cameraPosition:self.cameraPosition];
    
    // 縦持ちの状態で初期化
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    // 最初のフィルタ
    [self setFilter:0 imageView:imageView];
    
    // カメラスタート
    [self.stillCamera startCameraCapture];
}

// カメラの停止
- (void)stopCamera
{
    if(self.stillCamera) {
        [self.stillCamera stopCameraCapture];
        self.stillCamera = nil;
    }
}

// カメラ切替
- (void)switchCameraPosition:(GPUImageView *)imageView
{
    // カメラ一時停止
    [self stopCamera];
    
    // カメラの切替
    if(self.cameraPosition == AVCaptureDevicePositionFront) {
        self.cameraPosition = AVCaptureDevicePositionBack;
    }
    else {
        self.cameraPosition = AVCaptureDevicePositionFront;
    }
    
    // カメラの再開
    [self startCamera:imageView];
}

#pragma mark - Filter

// フィルタの初期化
- (void)initializeFilter
{
    NSMutableArray *filterArray = [@[] mutableCopy];
    
    // 各フィルタを初期化し配列に追加
    
    // セピアフィルタ
    [filterArray addObject:[[GPUImageSepiaFilter alloc] init]];
    
    // グレースケールフィルタ
    [filterArray addObject:[[GPUImageGrayscaleFilter alloc] init]];
    
    // ハーフトーン
    [filterArray addObject:[[GPUImageHalftoneFilter alloc] init]];
    
    // スケッチフィルタ
    [filterArray addObject:[[GPUImageSketchFilter alloc] init]];
    
    // モザイクフィルタ
    [filterArray addObject:[[GPUImagePixellateFilter alloc] init]];
    
    // チルトシフトフィルタ
    [filterArray addObject:[[GPUImageTiltShiftFilter alloc] init]];
    
    self.filterArray = filterArray;
}

// 前のフィルタを適用
- (void)setPreviousFilter:(GPUImageView *)imageView
{
    // 現在のフィルタのインデックスを取得
    NSInteger index = [self previousFilterIndex];
    
    [self setFilter:index imageView:imageView];
}

// 次のフィルタを適用
- (void)setNextFilter:(GPUImageView *)imageView
{
    NSInteger index = [self nextFilterIndex];
    
    [self setFilter:index imageView:imageView];
}

// フィルタを適用
- (void)setFilter:(NSInteger)index imageView:(GPUImageView *)imageView
{
    // インデックスからフィルタを取得
    GPUImageFilter *filter = self.filterArray[index];
    
    [self removeTarget:imageView];
    
    self.currentFilter = filter;
    
    [self applyFilter:imageView];
}


// 現在適用されているフィルタのインデックス
- (NSInteger)currentFilterIndex
{
    return [self.filterArray indexOfObject:self.currentFilter];
}

// 前のフィルタのインデックス
- (NSInteger)previousFilterIndex
{
    // 現在のフィルタのインデックスを取得
    NSInteger index = [self currentFilterIndex];
    
    // インデックスを一つ前へ
    index--;
    
    // インデックスが範囲を超えていないか確認
    if(index < 0) {
        index = self.filterArray.count - 1;
    }
    
    return index;
}

// 次のフィルタのインデックス
- (NSInteger)nextFilterIndex
{
    // 現在のフィルタのインデックスを取得
    NSInteger index = [self currentFilterIndex];
    
    // インデックスを一つ次へ
    index++;
    
    // インデックスが範囲を超えていないか確認
    if(index >= self.filterArray.count) {
        index = 0;
    }
    
    return index;
}

// 現在のフィルタの削除
- (void)removeTarget:(GPUImageView *)view
{
    if(self.currentFilter) {
        [self.stillCamera removeTarget:self.currentFilter];
        [self.currentFilter removeTarget:view];
    }
}

// フィルタの適用
- (void)applyFilter:(GPUImageView *)view
{
    // 新しいフィルタの追加
    [self.stillCamera addTarget:self.currentFilter];
    
    // プレビューにも適用
    [self.currentFilter addTarget:view];
}

#pragma mark - Take Photo

// 写真をとる
- (void)takePhoto
{
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.currentFilter
                                       withCompletionHandler:^(UIImage *processedImage, NSError *error){
                                           if(!error) {
                                               UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                           }
                                       }];
}

// 写真の保存に失敗したときに呼ばれる
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // エラーのとき
    if(error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"写真の保存に失敗しました。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end