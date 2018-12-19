//
//  KTakePhotoViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/15.
//  Copyright © 2018年 Javictory. All rights reserved.
//

/***
 *  QuartzCore.framework
 *  AVFundation.framework
 *  MobileCoreServices.framework
 *  Systemconfiguration.framework
 **/

#import "KTakePhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <VIPhotoView.h>
@interface KTakePhotoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) UIButton *takePhoto;
@property(nonatomic,strong) UIButton *takeCamera;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) VIPhotoView *viImageV;


@property(nonatomic,strong) UIImagePickerController *imagePickerCtr;
@property(nonatomic,assign, getter=isShowState) BOOL showState;

@end

@implementation KTakePhotoViewController

-(UIImagePickerController *)imagePickerCtr{
    if (!_imagePickerCtr) {
        _imagePickerCtr = [[UIImagePickerController alloc] init];
        _imagePickerCtr.delegate = self;
        //iOS8以后拍照的页面跳转会卡顿几秒中，加入这个属性，卡顿消失
        _imagePickerCtr.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    return _imagePickerCtr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    self.navigationController.title = @"takePhoto";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view addSubview:self.takePhoto];
    [self.view addSubview:self.takeCamera];
    [self.view addSubview:self.imageV];
    [self setMasonry];
}

-(UIButton *)takePhoto{
    if (!_takePhoto) {
        _takePhoto = [[UIButton alloc] init];
        [_takePhoto setTitle:@"点击获取照片" forState:UIControlStateNormal];
        [_takePhoto setBackgroundColor:[UIColor orangeColor]];
        [_takePhoto setTintColor:[UIColor whiteColor]];
        [_takePhoto addTarget:self action:@selector(onTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhoto;
}

-(UIButton *)takeCamera{
    if (!_takeCamera) {
        _takeCamera = [[UIButton alloc] init];
        [_takeCamera setTitle:@"点击拍照" forState:UIControlStateNormal];
        [_takeCamera setBackgroundColor:[UIColor orangeColor]];
        [_takeCamera setTintColor:[UIColor whiteColor]];
        [_takeCamera addTarget:self action:@selector(onTakeCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takeCamera;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.backgroundColor = [UIColor clearColor];
        /**
         *  UIViewContentModeCenter
         *  横向和纵向都是居中。图片不会拉伸或者压缩，就是按照imageView的frame和图片的大小来居中显示的。
         *  1、图片比view的区域更大。这个时候会截取图片的中间部位显示在frame区域里面。
         *  2、图片比view的区域更小。这个时候图片会完整的显示在frame的中间位置。
         *  UIViewContentModeScaleAspectFill
         *  1、图片会拉伸或者压缩以适应frame的边界，而且是适应更小的边
         *  2、图片适应最小的边铺开显示，更大的边会超出frame
         *  UIViewContentModeScaleAspectFit
         *  1、图片会拉伸或者压缩以适应frame的边界，而且是适应更大的边
         *  如果在默认情况，图片的多出来的部分还是会显示屏幕上。如果不希望超过frame的区域显示在屏幕上要设置。clipsToBounds属性
         */
//        _imageV.contentMode =  UIViewContentModeCenter;
        _imageV.clipsToBounds  = YES;
        [_imageV setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageV.contentMode =  UIViewContentModeScaleAspectFit;

        /**
         *  给图片添加手势，要设置userInteractionEnabled为YES
         */
        _imageV.userInteractionEnabled = YES; // 设置图片可以交互
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)]; // 设置手势
        [_imageV addGestureRecognizer:singleTap]; // 给图片添加手势
    }
    return _imageV;
}

-(void)setMasonry{
    [_takePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(64 + DSCommonMargin);
        make.left.mas_equalTo(self.view).mas_offset(DSCommonMargin);
        make.right.mas_equalTo(self.view).mas_offset(-DSCommonMargin);
        make.height.mas_offset(44);
    }];
    [_takeCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.takePhoto.mas_bottom).mas_offset(DSCommonMargin);
        make.left.mas_equalTo(self.view).mas_offset(DSCommonMargin);
        make.right.mas_equalTo(self.view).mas_offset(-DSCommonMargin);
        make.height.mas_offset(44);
    }];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.takeCamera.mas_bottom).mas_offset(DSCommonMargin);
        make.left.mas_equalTo(self.view).mas_offset(DSCommonMargin);
        make.height.mas_offset(100);
        make.width.mas_offset(100);
    }];
    [_viImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.takeCamera.mas_bottom).mas_offset(DSCommonMargin);
        make.left.mas_equalTo(self.imageV.mas_right).mas_offset(DSCommonMargin);
        make.height.mas_offset(100);
        make.width.mas_offset(100);
    }];
}

#pragma mark -- 相册
-(void)onTakePhoto{
    // 设置选择载相册的图片或视频
    self.imagePickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //是否允许编辑
    self.imagePickerCtr.allowsEditing = NO;
    // 显示picker视图控制器
    [self presentViewController:self.imagePickerCtr animated:YES completion:nil];
}

#pragma mark --相机
-(void)onTakeCamera{
    //拍照或拍视频
    self.imagePickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置拍摄照片
    self.imagePickerCtr.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    // 设置使用手机的后置摄像头（默认使用后置摄像头）
    _imagePickerCtr.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    // 设置使用手机的前置摄像头。
    //_imagePickerCtr.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    // 设置拍摄的照片允许编辑
    _imagePickerCtr.allowsEditing = YES;
    [self presentViewController:_imagePickerCtr animated:YES completion:nil];
}

- (void)tapImageView:(UIButton *)sender{
    if (_imageV.width == 100) {
        //隐藏导航栏
        self.navigationController.navigationBar.hidden = YES;
        //隐藏状态栏，需手动调用刷新
        self.showState = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        _imageV.backgroundColor = [UIColor blackColor];
        [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.view).mas_offset(0);
            make.center.mas_equalTo(self.view);
        }];
    }else{
        //显示导航栏
        self.navigationController.navigationBar.hidden = NO;
        //显示状态栏，需手动调用刷新
        self.showState = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        _imageV.backgroundColor = [UIColor whiteColor];
        [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.takeCamera.mas_bottom).mas_offset(DSCommonMargin);
            make.left.mas_equalTo(self.view).mas_offset(DSCommonMargin);
            make.height.mas_offset(100);
            make.width.mas_offset(100);
        }];
    }
}
- (BOOL)prefersStatusBarHidden{
    return self.isShowState;
}

#pragma mark -- delegate
#pragma mark - 当用户选择图片或者拍照完成时，调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"info--->成功：%@", info);
    // 获取用户拍摄的是照片还是视频
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断获取类型：图片，并且是从相册取出的照片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage *theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"Image.width = %.2f",theImage.size.width);
        NSLog(@"Image.height = %.2f",theImage.size.height);
        NSLog(@"Image.scale = %.2f",theImage.scale);
        NSLog(@"Image.Orientation = %ld",[theImage imageOrientation]);
//        NSData *data = [NSData dataWithContentsOfFile:[info objectForKey:UIImagePickerControllerImageURL]];
        [_imageV setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];

    }else{
        //判断获取类型：图片，并且是通过拍照获得
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *theImage =nil;
            // 判断，图片是否允许修改
            if ([picker allowsEditing])
            {
                // 获取用户编辑之后的图像
                theImage = [info objectForKey:UIImagePickerControllerEditedImage];
            }else {
                // 获取原始的照片
                theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            // 保存图片到相册中
            UIImageWriteToSavedPhotosAlbum(theImage,self,nil,nil);
            [_imageV setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"用户取消的拍摄！");
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存图片完成");
}
@end








