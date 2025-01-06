//
//  ListViewController.m
//  GPSLogger
//
//  Created by Yoshitaka Yamashita on 2013/09/06.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController ()

@property(nonatomic, weak) NSArray *logArray;

@end

@implementation ListViewController

//----------------------------------------
#pragma mark - View Lifecycle
//----------------------------------------

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // NSUserDefaultsのシングルトンインスタンスからデータを取得しておく
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.logArray = [defaults objectForKey:KEY_LOGARRAY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------
#pragma mark - Table view data source
//----------------------------------------

// TableViewのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// TableViewの項目数(ログをとった数)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.logArray) return 0;
    
    return self.logArray.count;
}

// 日付データを渡す
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *logDict = self.logArray[indexPath.row];
    
    // NSDateをフォーマット指定してNSStringへ変換
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString *strDate = [formatter stringFromDate:logDict[KEY_DATE]];
    
    // ラベルに指定
    cell.textLabel.text = strDate;
    
    return cell;
}

//----------------------------------------
#pragma mark - Storyboard
//----------------------------------------

// 詳細画面へ遷移時、現在選択中の道のりデータをDetailViewControllerに渡す
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailViewController = (DetailViewController *)segue.destinationViewController;
        NSDictionary *logDict = self.logArray[self.tableView.indexPathForSelectedRow.row];
        detailViewController.logArray = logDict[KEY_LOGS];
    }
}

@end
