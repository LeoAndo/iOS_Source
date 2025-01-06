//
//  ViewController.m
//  StepCounter
//
//  Created by Yoshitaka Yamashita on 2013/11/02.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) MotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UILabel *currentStepsLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

//----------------------------------------
#pragma mark - View LifeCycle
//----------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMotionManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------
#pragma mark - Motion Manager
//----------------------------------------

// モーション管理オブジェクトの設定
- (void)configureMotionManager
{
    // モーション管理オブジェクト
    self.motionManager = [[MotionManager alloc] init];
    
    // 歩数計に対応している場合
    if([self.motionManager isStepCountingAvailable])
    {
        // デリゲート設定
        self.motionManager.delegate = self;
        // 歩数取得クエリを開始
        [self.motionManager startQueryStepCount];
        [self.motionManager startStepContinuingUpdates];
    }
    else
    {
        // 対応していなければメッセージ表示
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"M7コプロセッサ搭載端末でお試しください"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

//----------------------------------------
#pragma mark - Table View Delegate
//----------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.motionManager.stepsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルを取得
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"Cell"];
    
    // 日付表示用フォーマッタを作成
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    
    //
    NSDictionary *dict = self.motionManager.stepsArray[indexPath.row];
    
    NSString *strStep = [NSString stringWithFormat:@"%@", dict[kDictionaryStepsKey]];
    NSString *strDate = [formatter stringFromDate:dict[kDictionaryDateKey]];
    
    cell.textLabel.text = strDate;
    cell.detailTextLabel.text = strStep;
    
    return cell;
}

//----------------------------------------
#pragma mark - Motion Manager Delegate
//----------------------------------------

// 一週間分のモーションデータの取得が完了したとき
- (void)motionManagerQueryFinished
{
    // テーブルビューを更新
    [self.tableView reloadData];
}

// 今日の歩数が更新されたとき
- (void)motionManagerCurrentStepsUpdated:(NSInteger)numberOfSteps
{
    // ラベルに表示
    self.currentStepsLabel.text = [NSString stringWithFormat:@"%ld", numberOfSteps];
}

@end