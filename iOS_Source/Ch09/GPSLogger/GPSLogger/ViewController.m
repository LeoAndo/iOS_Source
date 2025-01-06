//
//  ViewController.m
//  GPSLogger
//
//  Created by Yoshitaka Yamashita on 2013/09/04.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;

@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (readonly) BOOL isStarted;
@property (readonly) BOOL isChasing;    // 現在地を追跡しているかどうか

- (IBAction)performUserLocationButtonAction:(UIBarButtonItem *)sender;
- (IBAction)performStartButtonAction:(UIButton *)sender;

@end

@implementation ViewController

//----------------------------------------
#pragma mark - View Lifecycle
//----------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // MapViewの表示範囲を設定
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
    // Location Managerの初期化
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    // パンジェスチャーを追加 (中心座標が現在地から移動されたことを検出するため)
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewPanGesture)];
    panGesture.delegate = self;
    [self.mapView addGestureRecognizer:panGesture];
    
    // 各フラグを初期化
    _isStarted = NO;
    _isChasing = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------
#pragma mark - Gesture Recognizer
//----------------------------------------

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// パンジェスチャー検知時
- (void)mapViewPanGesture
{
    _isChasing = NO;
    self.userLocationButton.hidden = NO;
}

//----------------------------------------
#pragma mark - Perform
//----------------------------------------

- (void)start
{
    self.startButton.title = @"終了";
    self.historyButton.enabled = NO;
    
    self.locationArray = [NSMutableArray array];
}

- (void)stop
{
    self.startButton.title = @"スタート";
    self.historyButton.enabled = YES;
    
    [self save];
}

// 保存
- (void)save
{
    // 今回の道のりを日付とともに辞書型変数へ
    NSDictionary *logDict = @{KEY_DATE: [NSDate date], KEY_LOGS: self.locationArray};
    
    // シングルトンインスタンスを取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // ログの配列を取得
    NSArray *logArray = [defaults arrayForKey:KEY_LOGARRAY];
    
    // もし存在しなければ新しく作る
    if(!logArray) {
        logArray = @[];
    }
    
    // 可変長配列に変換し追加
    NSMutableArray *newArray = [logArray mutableCopy];
    [newArray addObject:logDict];
    
    // 新しい配列をセット
    [defaults setObject:newArray forKey:KEY_LOGARRAY];
    
    // 書き込み
    [defaults synchronize];
}

//----------------------------------------
#pragma mark - Location Manager
//----------------------------------------

// 現在地の変化を検知
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
        
    // 現在地の表示
    if(_isChasing) {
        [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    }
    
    // 記録と軌跡の表示
    if(_isStarted) {
        NSDictionary *coordinate = @{KEY_LATITUDE: @(location.coordinate.latitude),
                                     KEY_LONGITUDE: @(location.coordinate.longitude)};
        [_locationArray addObject:coordinate];
    }
}

//----------------------------------------
#pragma mark - Button Action
//----------------------------------------

// スタートボタンクリック時
- (void)performStartButtonAction:(UIButton *)sender
{
    _isStarted = !_isStarted;
    
    if(_isStarted) {
        [self start];
    }
    else {
        [self stop];
    }
}

// 現在地ボタンクリック時
- (void)performUserLocationButtonAction:(UIBarButtonItem *)sender
{
    _isChasing = YES;
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    self.userLocationButton.hidden = YES;
}

@end
