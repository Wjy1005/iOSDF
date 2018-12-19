//
//  KWeChatImagesViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/21.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KWeChatImagesViewController.h"
#import "GKPhoto.h"
#import "GKPhotoBrowser.h"
@interface KWeChatImagesViewController ()

@end

@implementation KWeChatImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片展示（仿微信）";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    NSMutableArray *photos = [NSMutableArray new];
    NSMutableArray *dataSource = [NSMutableArray new];
    [dataSource addObject:@"http://b-ssl.duitang.com/uploads/item/201412/28/20141228172725_LMRyx.jpeg"];
    [dataSource addObject:@"http://b-ssl.duitang.com/uploads/item/201412/28/20141228172725_LMRyx.jpeg"];
    [dataSource addObject:@"http://b-ssl.duitang.com/uploads/item/201412/28/20141228172725_LMRyx.jpeg"];
    [dataSource addObject:@"http://b-ssl.duitang.com/uploads/item/201412/28/20141228172725_LMRyx.jpeg"];
////////
    [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        NSLog(@"%@",obj);
        photo.url = [NSURL URLWithString:obj];
    //    photo.image = [UIImage imageNamed:@"pikaqiu"];
        [photos addObject:photo];
    }];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self];
    
}


@end
