//
//  KNavController.m
//  iOSDemo
//
//  Created by king on 2019/7/29.
//  Copyright © 2019 Javictory. All rights reserved.
//

#import "KNavController.h"

@interface KNavController ()<UIGestureRecognizerDelegate>

@end

@implementation KNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [self setNavTitltView];
    
    UIBarButtonItem *rightButoomItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(onRightButoonItem)];
    self.navigationItem.rightBarButtonItem = rightButoomItem;
    
    // 设置导航子控制器按钮的加载样式
    // 将这个页面自定义的后退键置为nil
    UINavigationItem *vcBtnItem= [self navigationItem];
    vcBtnItem.leftBarButtonItem = nil;
    // hidesBackButton隐藏返回按钮,注意隐藏之后（如果没提供其他方式返回）就不能返回到上一个视图，往右滑动屏幕也不会返回
    // 使用原生自带的后退键
     [self.navigationItem setHidesBackButton:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 释放协议拦截
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}
- (UIView *)setNavTitltView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 80, 44)];
    view.backgroundColor = [UIColor redColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLab.text = @"Nav标题";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.center = view.center;
    
    [view addSubview:titleLab];
    return view;
}

- (void)onRightButoonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO; // 默认为支持右滑反回
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
