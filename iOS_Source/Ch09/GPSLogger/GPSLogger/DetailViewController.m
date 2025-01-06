//
//  DetailViewController.m
//  GPSLogger
//
//  Created by Yoshitaka Yamashita on 2013/09/06.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "DetailViewController.h"

#define MIN_LATITUDE_DELTA 0.002
#define MIN_LONGITUDE_DELTA 0.002

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 距離
    CLLocationDegrees distance = [self calculateDistance:self.logArray];
    
    // 距離が1,000mを超えた場合km表記にする
    if(distance < 1000.0f) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f m", distance];
    }
    else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f km", distance/1000.0f];
    }

    // 表示するマップ上の領域
    MKCoordinateRegion region = [self calculateRegion:self.logArray];
    [self.mapView setRegion:region animated:animated];
    
    // Polylineを作成
    MKPolyline *polyline = [self createPolyline:self.logArray];
    [self.mapView addOverlay:polyline];
}

//----------------------------------------
#pragma mark - MKMapView Delegate
//----------------------------------------

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    // 青色で太さ4.0の線を描画
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 4.0f;
    renderer.strokeColor = [UIColor blueColor];

    return renderer;
}


// 道のりの配列をMKPolylineにする
- (MKPolyline *)createPolyline:(NSArray *)logArray
{
    // 要素数分のメモリを確保
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * logArray.count);
    
    // 配列の要素数分繰り返す
    for(NSInteger i=0; i<logArray.count; i++)
    {
        // 配列からi番目を取得
        NSDictionary *logDict = logArray[i];
        
        // ログデータから値を取得
        double latitude = [logDict[KEY_LATITUDE] doubleValue];
        double longitude = [logDict[KEY_LONGITUDE] doubleValue];
        
        // 配列に追加
        coordinates[i] = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    // 道のりを示す線を作成
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates
                                                         count:logArray.count];
    
    // 確保したメモリの解放
    free(coordinates);
    
    return polyline;
}

// 道のりの配列から距離を求める
- (CLLocationDegrees)calculateDistance:(NSArray *)logArray
{   
    // 距離の合計
    double distance = 0.0f;
    // 一つ前のLocation
    CLLocation *previousLocation = nil;
    
    // 配列の要素数分繰り返す
    for(NSInteger i=0; i<logArray.count; i++)
    {
        // 配列からi番目を取得
        NSDictionary *logDict = logArray[i];
        
        // ログデータからCLLocationのインスタンスを作成
        double latitude = [logDict[KEY_LATITUDE] doubleValue];
        double longitude = [logDict[KEY_LONGITUDE] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        // 距離を加算
        if(previousLocation) {
            distance += [location distanceFromLocation:previousLocation];
        }
        
        // 最後の位置を記録しておく
        previousLocation = location;
    }
    
    return distance;
}

// 道のりの配列からマップ上の位置と縮尺を決める
- (MKCoordinateRegion)calculateRegion:(NSArray *)logArray
{
    // 東西南北の端を確保する配列を作成
    double east, west, north, south;

    // 配列の要素数分繰り返す
    for(NSInteger i=0; i<logArray.count; i++)
    {
        // 配列からi番目を取得
        NSDictionary *logDict = logArray[i];
        
        // ログデータから値を取得
        double latitude = [logDict[KEY_LATITUDE] doubleValue];
        double longitude = [logDict[KEY_LONGITUDE] doubleValue];
        
        // 東西南北の端を取得しておく
        if(i==0) {
            north = latitude;
            south = latitude;
            east = longitude;
            west = longitude;
        }
        else {
            north = fmax(latitude, north);
            south = fmin(latitude, south);
            east = fmax(longitude, east);
            west = fmin(longitude, west);
        }
    }
    
    // マップ上の幅と高さを決定
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(north - south), fabs(east - west));
    
    // 中心座標を決定
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(north - (span.latitudeDelta * 0.5),
                                                               east - (span.longitudeDelta * 0.5));
    
    // 縮尺が小さくなりすぎないよう最小値を設定
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    region.span.latitudeDelta = fmax(region.span.latitudeDelta, MIN_LATITUDE_DELTA);
    region.span.longitudeDelta = fmax(region.span.longitudeDelta, MIN_LONGITUDE_DELTA);

    // 領域をMapViewのアスペクト比に合わせる
    MKCoordinateRegion mapRegion = [self.mapView regionThatFits:region];
    
    return mapRegion;
}

@end
