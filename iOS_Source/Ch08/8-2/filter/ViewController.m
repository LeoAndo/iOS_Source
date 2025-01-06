//
//  ViewController.m
//  filter
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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

- (IBAction)performImageSelectButton:(id)sender
{
    // Image Picker Controllerを作成
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    
    // 参照先はフォトライブラリに設定
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Image Picker Controllerを表示
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Pickerを閉じる
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 選択された画像を取得
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // セピアフィルタを用意
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    
    // 選択された画像にフィルタを適用しImage Viewへ反映
    self.imageView.image = [sepiaFilter imageByFilteringImage:originalImage];
}

@end
