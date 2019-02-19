//
//  KVideoPickerViewController.m
//  iOSDemo
//
//  Created by Javictory on 2019/1/23.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "KVideoPickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WBTakeVideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@interface KVideoPickerViewController ()<WBVideoViewControllerDelegate, TakeVideoDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *vedioBtn;
@property (nonatomic, strong) UIButton *getVedioBtn;
@property (nonatomic, strong) UIImagePickerController *imagePickerCtr;

@end

@implementation KVideoPickerViewController



-(UIButton *)vedioBtn{
    if (!_vedioBtn) {
        _vedioBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 300, 50)];
        [_vedioBtn setTitle:@"拍摄视频" forState:UIControlStateNormal];
        [_vedioBtn setBackgroundColor:[UIColor orangeColor]];
        [_vedioBtn setTintColor:[UIColor whiteColor]];
        [_vedioBtn addTarget:self action:@selector(vedioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vedioBtn;
}

-(UIButton *)getVedioBtn{
    if (!_getVedioBtn) {
        _getVedioBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.vedioBtn.frame) + 10, 300, 50)];
        [_getVedioBtn setTitle:@"获取视频" forState:UIControlStateNormal];
        [_getVedioBtn setBackgroundColor:[UIColor orangeColor]];
        [_getVedioBtn setTintColor:[UIColor whiteColor]];
        [_getVedioBtn addTarget:self action:@selector(getVedioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getVedioBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self.vedioBtn];
    [self.view addSubview:self.getVedioBtn];
    // Do any additional setup after loading the view.
}


#pragma mark -- 获取视频
- (void)getVedioBtnClick: (UIButton *)button {
    [self getVideo];
}

- (void)getVideo{
    // 设置选择载相册的图片或视频
    self.imagePickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.imagePickerCtr.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    //    self.imagePickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //是否允许编辑
    self.imagePickerCtr.allowsEditing = NO;
    // 显示picker视图控制器
    [self presentViewController:self.imagePickerCtr animated:YES completion:nil];
    
}
#pragma mark -- 拍摄视频
- (void)vedioBtnClick:(UIButton *)button {
    [self recordVideo];
}

- (void)recordVideo {
    NSString *unUserInfo = nil;
    if (TARGET_IPHONE_SIMULATOR) {
        unUserInfo = @"您的设备不支持此功能";
    }
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoAuthStatus == PHAuthorizationStatusRestricted || videoAuthStatus == PHAuthorizationStatusDenied){
        unUserInfo = @"相机访问受限";
    }
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioAuthStatus == PHAuthorizationStatusRestricted || audioAuthStatus == PHAuthorizationStatusDenied){
        unUserInfo = @"录音访问受限";
    }
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied){
        unUserInfo = @"相册访问权限受限";
    }
    if (unUserInfo != nil) {
        [self alertWithClick:unUserInfo];
    } else {
        [self pushWithTakeVideo];
    }
}

- (void)showVideoPicker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *title = @"请选择";
        NSString *cancelTitle = @"取消";
        NSString *recordVideoButtonTitle = @"拍摄";
        NSString *chooseFromLibraryButtonTitle = @"从相册获取";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            //           reject(unUserInfo, , nil);
        }];
        [alertController addAction:cancelAction];
        
        UIAlertAction *recordVideoAction = [UIAlertAction actionWithTitle:recordVideoButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self recordVideo];
        }];
        [alertController addAction:recordVideoAction];
        
        UIAlertAction *chooseFromLibraryAction = [UIAlertAction actionWithTitle:chooseFromLibraryButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self getVideo];
        }];
        [alertController addAction:chooseFromLibraryAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)pushWithTakeVideo {
    WBTakeVideoViewController *videoVC = [[WBTakeVideoViewController alloc]init];
    videoVC.delegate = self;
    videoVC.takeDelegate = self;
    videoVC.vedioBlock = ^(NSDictionary * _Nonnull dic) {
        NSLog(@"%@",dic);
    };
    [self presentViewController:videoVC animated:YES completion:nil];
}

- (void)alertWithClick:(NSString *)msg {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:1];
    
    UIAlertAction *action    = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //        [SVProgressHUD dismiss];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- WBTake delegate
- (void)videoViewController:(WBTakeVideoViewController *)videoController didRecordVideo:(WBVideoModel *)videoModel{
    
}

- (void)takeVideoDelegateAction:(NSString *)videoPath{
    NSLog(@"videoPath: %@",videoPath);
}

#pragma mark -- delegate
#pragma mark - 当用户选择图片或者拍照完成时，调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"info--->成功：%@", info);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self getVideoInfoWithSourcePath:[info objectForKey:UIImagePickerControllerMediaURL]]];
    
    NSLog(@"%@",dic);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"用户取消！");
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSURL *)path{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:path options:opts]; // 初始化视频媒体文件
    NSUInteger second = 0;
    second =  (int)roundf(1.0 * urlAsset.duration.value / urlAsset.duration.timescale); // 获取视频总时长,单位秒
    
    return @{ @"duration" : @(second)};
}

@end
