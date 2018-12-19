//
//  KImagesViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/20.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KImagesViewController.h"
#import <SDCycleScrollView.h>

@interface KImagesViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation KImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图片轮播";
    [self.view addSubview:self.cycleScrollView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.frame delegate:self placeholderImage:[UIImage imageNamed:@"icon_placeholder.png"]];
        _cycleScrollView.backgroundColor = [UIColor redColor];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542692313107&di=cf6245a72f7961beda79cb05fd1a5dfe&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201502%2F28%2F20150228143417_Effcj.jpeg"]];
        [array addObject:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542692313107&di=cf6245a72f7961beda79cb05fd1a5dfe&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201502%2F28%2F20150228143417_Effcj.jpeg"]];
        [array addObject:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542692313107&di=cf6245a72f7961beda79cb05fd1a5dfe&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201502%2F28%2F20150228143417_Effcj.jpeg"]];
        _cycleScrollView.imageURLStringsGroup = array;
        // 设置pageControl居右，默认居中
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //标题数组（数组元素个数必须和图片数组元素个数保持一致
        // 如果设置title数组，则会在图片下面添加标题
        _cycleScrollView.titlesGroup = @[@"皮卡丘1", @"皮卡丘2", @"皮卡丘3"];
        // 自定义轮播时间间隔
        _cycleScrollView.autoScrollTimeInterval = 3;
    }
    return _cycleScrollView;
}

#pragma mark -- delegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了第%ld张照片",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"滚动到第%ld张照片",index);
}

@end
