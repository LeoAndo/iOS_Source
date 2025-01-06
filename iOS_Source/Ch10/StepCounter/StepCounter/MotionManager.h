//
//  MotionManager.h
//  StepCounter
//
//  Created by Yoshitaka Yamashita on 2013/11/02.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MotionManagerDelegate <NSObject>

- (void)motionManagerQueryFinished;
- (void)motionManagerCurrentStepsUpdated:(NSInteger)numberOfSteps;

@end

@interface MotionManager : NSObject

@property(nonatomic, strong) id<MotionManagerDelegate> delegate;
@property(nonatomic, strong) NSMutableArray *stepsArray;

- (BOOL)isStepCountingAvailable;
- (void)startQueryStepCount;
- (void)startStepContinuingUpdates;

@end