//
//  KDownloadFileViewController.m
//  iOSDemo
//
//  Created by Javictory on 2019/1/23.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "KDownloadFileViewController.h"
#import "SYDownloadTask.h"

@interface KDownloadFileViewController ()

@property (nonatomic, strong) SYDownloadTask *downloadTask;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation KDownloadFileViewController

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, 50, 300, 20)];
        _progressView.progress = 0;
        _progressView.backgroundColor = [UIColor blueColor];
    }
    return _progressView;
}

-(UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.progressView.frame) + 10, 300, 50)];
        [_button setTitle:@"开始下载" forState:UIControlStateNormal];
        [_button setTitle:@"停止下载" forState:UIControlStateSelected];
        [_button setBackgroundColor:[UIColor orangeColor]];
        [_button setTintColor:[UIColor whiteColor]];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.button];
}

// 使用，即实例化，或开始，暂停下载，继续下载
- (void)buttonClick:(UIButton *)button
{
    if (button.selected)
    {
        if (self.downloadTask)
        {
            [self.downloadTask downloadStop];
        }
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        if (self.downloadTask)
        {
            [self.downloadTask downloadStartWithData:self.downloadTask.resumeData complete:^(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes) {
                
                NSLog(@"1 下载状态：%@", (isFinish ? @"下载完成" : @"正在下载"));
                NSLog(@"1 下载文件路径：%@", filePath);
                NSLog(@"1 已下载：%f%%(downloadBytes = %f, totalBytes = %f)", (float)(downloadBytes)/(float)(totalBytes), (float)downloadBytes, (float)totalBytes);
                
                weakSelf.progressView.progress = (float)(downloadBytes)/(float)(totalBytes);
                if (isFinish)
                {
                    button.selected = NO;
                }
            }];
        }
        else
        {
            NSString *string = @"https://dldir1.qq.com/weixin/mac/WeChat_2.3.22.18.dmg";
            //            NSString *string = @"http://www.68mtv.com/index/down/id/61109";
            //            NSString *string = @"http://imgsrc.baidu.com/baike/pic/item/203fb80e7bec54e7c5cda6b3bd389b504fc26a7e.jpg";
            self.downloadTask = [[SYDownloadTask alloc] init];
            [self.downloadTask downloadStartWithURL:string complete:^(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes) {
                NSLog(@"2 下载状态：%@", (isFinish ? @"下载完成" : @"正在下载"));
                NSLog(@"2 下载文件路径：%@", filePath);
                NSLog(@"2 已下载：%f%%(downloadBytes = %f, totalBytes = %f)", (float)(downloadBytes)/(float)(totalBytes), (float)downloadBytes, (float)totalBytes);
                
                weakSelf.progressView.progress = (float)(downloadBytes)/(float)(totalBytes);
                if (isFinish)
                {
                    button.selected = NO;
                }
            }];
        }
    }
    
    button.selected = !button.selected;
    
}

@end
