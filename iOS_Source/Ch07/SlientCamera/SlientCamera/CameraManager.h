//
//  CameraManager.h
//  SlientCamera
//
//  Created by Yoshitaka Yamashita on 2013/10/31.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraManager : NSObject
<
    AVCaptureVideoDataOutputSampleBufferDelegate
>

- (void)takePhoto;

@end
