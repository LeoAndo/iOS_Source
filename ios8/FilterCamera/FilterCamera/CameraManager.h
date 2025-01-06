//
//  CameraManager.h
//  FilterCamera
//
//  Created by Yoshitaka Yamashita on 2013/11/03.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraManager : NSObject

// カメラキャプチャの開始・停止
- (void)startCamera:(GPUImageView *)imageView;
- (void)stopCamera;

// 前面・背面カメラを切り替え
- (void)switchCameraPosition:(GPUImageView *)imageView;

// 次のフィルタ・前のフィルタへ切り替え
- (void)setPreviousFilter:(GPUImageView *)imageView;
- (void)setNextFilter:(GPUImageView *)imageView;

// 写真を撮影して保存する
- (void)takePhoto;

@end