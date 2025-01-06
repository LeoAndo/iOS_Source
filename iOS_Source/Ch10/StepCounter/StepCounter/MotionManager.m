//
//  MotionManager.m
//  StepCounter
//
//  Created by Yoshitaka Yamashita on 2013/11/02.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "MotionManager.h"

#define kMaxDays 7		// 取得する最大日数

@interface MotionManager()

@property(readwrite) NSInteger todaySteps;
@property(nonatomic, strong) CMStepCounter *stepCounter;

@end

@implementation MotionManager

- (id)init
{
    self = [super init];
    if (self) {
        _stepCounter = [[CMStepCounter alloc] init];
    }
    return self;
}

// 歩数計に対応しているかどうか
- (BOOL)isStepCountingAvailable
{
    return [CMStepCounter isStepCountingAvailable];
}

// 歩数増加の監視を開始
- (void)startStepContinuingUpdates
{
    if([self isStepCountingAvailable])
    {
        // StepCounterのオブジェクト作成
        [self.stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 updateOn:1
                                              withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error)
         {
             [self.delegate motionManagerCurrentStepsUpdated:self.todaySteps + numberOfSteps];
         }];
    }
}

// 歩数取得クエリを開始
- (void)startQueryStepCount
{
    self.stepsArray = [NSMutableArray array];
    
    if([self isStepCountingAvailable])
    {
        // 今日の0時0分
        NSDate *todayDate = [self startOfDay:[NSDate date]];
        
        // 一日分のインターバル
        NSTimeInterval oneDayInterval = 24.0f * 60.0f * 60.0f;
        
        for(NSInteger i=0; i<kMaxDays; i++)
        {
            //
            NSTimeInterval interval = oneDayInterval * i;
            
            NSDate *fromDate = [todayDate dateByAddingTimeInterval:-interval];
            NSDate *toDate = [fromDate dateByAddingTimeInterval:oneDayInterval];
            
            // 歩数を取得
            [self.stepCounter queryStepCountStartingFrom:fromDate
                                                      to:toDate
                                                 toQueue:[NSOperationQueue mainQueue]
                                             withHandler:^(NSInteger numberOfSteps, NSError *error)
             {
                 if(!error)
                 {
                     // 取得したデータが今日のものであれば
                     if([fromDate isEqualToDate:todayDate])
                     {
                         self.todaySteps = numberOfSteps;
                         [self.delegate motionManagerCurrentStepsUpdated:self.todaySteps];
                     }
                     else {
                         NSDictionary *dict = @{kDictionaryDateKey: fromDate, kDictionaryStepsKey: @(numberOfSteps)};
                         [self.stepsArray addObject:dict];
                     }
                     
                     // 歩数の取得が完了していれば
                     if(self.stepsArray.count == kMaxDays-1)
                     {
                         // 配列を日付降順にソート
                         [self.stepsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
                          {
                              NSDictionary *dict1 = obj1;
                              NSDictionary *dict2 = obj2;
                              
                              NSDate *date1 = dict1[kDictionaryDateKey];
                              NSDate *date2 = dict2[kDictionaryDateKey];
                              
                              return [date2 compare:date1];
                          }];
                         
                         // 完了をデリゲートに通知
                         [self.delegate motionManagerQueryFinished];
                     }
                 }
             }];
            
        }
    }
}

// 指定したDateの0時0分を返す
- (NSDate *)startOfDay:(NSDate *)date
{
    // 時刻を切り捨てる
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    // フォーマットに合わせて文字列化し、またNSDateに戻す
    NSString *strToday = [dateFormatter stringFromDate:date];
    NSDate *twelveDate = [dateFormatter dateFromString:strToday];
    
    return twelveDate;
}

@end
