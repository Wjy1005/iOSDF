//
//  KVideoPickerViewController.m
//  iOSDemo
//
//  Created by Javictory on 2019/3/4.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "KVideoPickerViewController.h"
#import "SCCameraVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVAsset.h>

@interface KVideoPickerViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *videoPickerBtn;
@property (nonatomic, assign) int recordTime;       //录制时间
@property (nonatomic, strong) UIImagePickerController *imagePickerCtr;

@end

@implementation KVideoPickerViewController

- (UIButton *)_videoPickerBtn {
    if (!_videoPickerBtn) {
        _videoPickerBtn = [[UIButton alloc] initWithFrame:CGRectMake(64, 0, KScreenWidth, 100)];
        [_videoPickerBtn setTitle:@"video" forState:UIControlStateNormal];
        [_videoPickerBtn addTarget:self action:@selector(clickVideoPicker:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoPickerBtn;
}

-(UIImagePickerController *)imagePickerCtr{
    if (!_imagePickerCtr) {
        _imagePickerCtr = [[UIImagePickerController alloc] init];
        _imagePickerCtr.delegate = self;
        //iOS8以后拍照的页面跳转会卡顿几秒中，加入这个属性，卡顿消失
        _imagePickerCtr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return _imagePickerCtr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_videoPickerBtn];
    
    self.recordTime = 10;
    // Do any additional setup after loading the view.
}

- (void)clickVideoPicker:(UIButton *)sender {
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
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

//检查权限，保证保存视频成功
- (void)recordVideo {
    NSString *unUserInfo = nil;
    if (TARGET_IPHONE_SIMULATOR) {
        unUserInfo = @"您的设备不支持此功能";
    }
    //保存一张不存在的图片，保证第一次访问时可以正常保存
    UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"logo1"], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    if (unUserInfo != nil) {
        [self alertWithClick:unUserInfo];
    } else {
        [self pushWithTakeVideo];
    }
}

#pragma mark -- 录制视频
- (void)pushWithTakeVideo {
    SCCameraVideoViewController *vc = [[SCCameraVideoViewController alloc] init];
    vc.recordTime = self.recordTime;
    vc.sendVideoBlock = ^(NSString *videofilePath, UIImage *image) {
        //保存首帧截图
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *thumPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"thumImg.png"]];
        [UIImagePNGRepresentation(image) writeToFile:thumPath atomically:YES];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- 相册获取
- (void)getVideo {
    // 设置选择载相册的图片或视频
    self.imagePickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerCtr.mediaTypes = @[(NSString *)kUTTypeMovie];
    //    self.imagePickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //是否允许编辑
    self.imagePickerCtr.allowsEditing = NO;
    // 显示picker视图控制器
    [self.navigationController presentViewController:self.imagePickerCtr animated:YES completion:nil];
}

//提示框
- (void)alertWithClick:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:1];
    UIAlertAction *action    = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:action];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil) {
    }else{
    }
}
@end
