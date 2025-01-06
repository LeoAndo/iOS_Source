//
//  ViewController.m
//  navigationcontroller
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // ナビゲーションコントローラが保持しているビューコントローラの数を取得し、タイトルに設定する
    NSString *title = [NSString stringWithFormat:@"%d", [self.navigationController.viewControllers count]];
    self.navigationItem.title = title;
    
    // ナビゲーションバーの右側のボタンを設定
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"次へ"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(performNextButtonAction:)];
    self.navigationItem.rightBarButtonItem = next;
    
    // ツールバーに表示するボタンの配列を作成
    NSMutableArray *toolbarItems = [NSMutableArray array];
    for (NSInteger i = 1; i < [self.navigationController.viewControllers count]; i++) {
        // ツールバーのボタンを押すと、n番目のビューコントローラに直接戻るようにする
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d", i]
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(performToolbarButtonAction:)];
        item.tag = i - 1;
        [toolbarItems addObject:item];
    }
    self.toolbarItems = toolbarItems;
}

- (void)performNextButtonAction:(UIBarButtonItem *)sender
{
    // "ViewController" を Storyboard ID に持つビューコントローラをインスタンス化し、ナビゲーションコントローラに追加
    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)performToolbarButtonAction:(UIBarButtonItem *)sender
{
    // n番目のビューコントローラを取得し、直接戻る
    ViewController *controller = self.navigationController.viewControllers[sender.tag];
    [self.navigationController popToViewController:controller animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UINavigationController *navigationController = self.navigationController;
    
    // ナビゲーションバーとツールバーの可視状態を切り替える
    [navigationController setNavigationBarHidden:!navigationController.navigationBarHidden animated:YES];
    [navigationController setToolbarHidden:!navigationController.toolbarHidden animated:YES];
}

@end
