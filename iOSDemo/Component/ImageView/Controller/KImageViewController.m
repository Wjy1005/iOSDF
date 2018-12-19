//
//  KImageViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/20.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KImageViewController.h"
#import <VIPhotoView.h>
@interface KImageViewController ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) VIPhotoView *viPhotoView;


@end

@implementation KImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"图片";
    [self.view addSubview:self.imageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 150, 150)];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542692313107&di=cf6245a72f7961beda79cb05fd1a5dfe&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201502%2F28%2F20150228143417_Effcj.jpeg"] placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
              [self.view addSubview:self.viPhotoView];
        }];
        _imageView.clipsToBounds  = YES;
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

-(VIPhotoView *)viPhotoView{
    if (!_viPhotoView) {
        UIImage *image = _imageView.image;
        _viPhotoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:image];
        _viPhotoView.autoresizingMask = (1 << 6) -1;
        
        [self.view addSubview:_viPhotoView];
    }
    return _viPhotoView;
}
@end
