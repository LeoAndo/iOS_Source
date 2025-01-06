//
//  ViewController.m
//  SlientCamera
//
//  Created by Yoshitaka Yamashita on 2013/10/05.
//  Copyright (c) 2013年 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"
#import "CameraManager.h"

// 最初に表示するページのURL
#define kHomePageURL @"http://www.apple.com/jp/"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (strong, nonatomic) CameraManager *cameraManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // カメラ管理クラス
    self.cameraManager = [[CameraManager alloc] init];
    
    // ホームページを表示
    [self navigate:kHomePageURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Web View

// 指定したURLをWebViewで開く
- (void)navigate:(NSString *)strUrl
{
    // キーボードを閉じる
    [self.urlField resignFirstResponder];
    
    // URLの文字列からリクエストを作成
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // リクエスト開始
    [self.webView loadRequest:request];
}

// WebViewが読み込みを開始した時
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // インジケータを表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// WebViewのエラー時
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // インジケータを表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // エラーを表示
    if(error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    // ボタンの有効・無効を切り替え
    [self enableButtons];
}

// WebViewの読み込みが完了したとき
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // インジケータを隠す
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 現在のURLをテキストボックスに反映
    self.urlField.text = webView.request.URL.absoluteString;
    
    // ボタンの有効・無効を切り替え
    [self enableButtons];
}

#pragma mark - User Interface

// 戻る・進むが出来る時のみボタンを有効化
- (void)enableButtons
{
    self.backButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
}

// キーボードのReturnが押されたとき
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 読み込みを開始
    [self navigate:self.urlField.text];
    
    return YES;
}

#pragma mark - IBAction

// シャッターボタン
- (IBAction)performCameraButton:(id)sender {
    // 撮影
    [self.cameraManager takePhoto];
}

// 開くボタン
- (IBAction)performNavigateButtonAction:(id)sender
{
    [self navigate:self.urlField.text];
}

// 戻るボタン
- (IBAction)performBackButtonAction:(id)sender
{
    [self.webView goBack];
}

// 進むボタン
- (IBAction)performNextButtonAction:(id)sender
{
    [self.webView goForward];
}

@end
