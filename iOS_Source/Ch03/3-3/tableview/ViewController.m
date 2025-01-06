//
//  ViewController.m
//  tableview
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong, nonatomic) NSMutableArray *numbers;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    // データの配列を初期化
    self.numbers = [NSMutableArray array];
    // ナビゲーションバーの左に編集ボタンを設定
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (IBAction)performAddButtonAction:(id)sender
{
    NSUInteger count = [self.numbers count];
    
    if (count == 0) {
        // データが0件の場合は、@1をデータに追加
        [self.numbers addObject:@1];
    } else {
        // データが1件以上ある場合は、最後の値に１を足した値をデータに追加
        NSNumber *last = [self.numbers lastObject];
        NSNumber *number = @([last integerValue] + 1);
        [self.numbers addObject:number];
    }
    
    // データの追加をテーブルビューに反映
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.numbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Storyboardで設定した identifier（BasicCell）に合致するセルを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
    
    // 配列から値を取得し、セルのラベルに設定
    NSNumber *number = self.numbers[indexPath.row];
    cell.textLabel.text = [number stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // データから該当のインデックスパスが示すオブジェクトを削除し、テーブルビューに反映
        [self.numbers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 該当のインデックスパスが示すデータを移動させる
    NSNumber *number = self.numbers[sourceIndexPath.row];
    [self.numbers removeObjectAtIndex:sourceIndexPath.row];
    [self.numbers insertObject:number atIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択した行のデータを取得し、ログに出力
    NSNumber *number = self.numbers[indexPath.row];
    NSLog(@"%@", number);
    
    // 選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // タップしたアクセサリの行のデータを取得し、アラートで表示
    NSNumber *number = self.numbers[indexPath.row];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[number stringValue]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
