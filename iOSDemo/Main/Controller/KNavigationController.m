//
//  KNavigationController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/13.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KNavigationController.h"

@interface KNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation KNavigationController


//第一次使用这个类的时候调用1次
+ (void)initialize
{
    // 设置UINavigationBarTheme
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
    
}


//设置UINavigationBarTheme主题
+ (void)setupNavigationBarTheme {
    //appearance方法返回一个导航栏的外观对象
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    //修改了这个外观对象，相当于修改了整个项目中的外观
    //设置导航栏背景颜色
    [navigationBar setBarTintColor:[UIColor lightGrayColor]];
    
    //设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = DSNavigationFont;
    
    //设置导航栏背景
    if (!iOS7){
        [navigationBar setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
        textAttrs[NSShadowAttributeName] = [[NSShadow alloc] init];
    }
    
    //设置NavigationBarItem文字的颜色
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    //在设置为NO之后控制器的view自动向下偏移64(导航栏高度的)
    navigationBar.translucent=NO;
    
    [navigationBar setTitleTextAttributes:textAttrs];
    
}

//设置UIBarButtonItem的主题
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DSCommonColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    // 设置高亮状态的文字属性
    //    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SWCommonColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateDisabled];
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 自定义后退键后遵守右滑手势协议
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断是否为栈底控制器
    if (self.viewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置导航子控制器按钮的加载样式
        UINavigationItem *vcBtnItem= [viewController navigationItem];
        
        vcBtnItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImageName:@"navigationbar_back_withtext" highImageName:@"navigationbar_back_withtext_highlighted" title:nil target:self action:@selector(back)];
        
        //        vcBtnItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithImageName:@"navigationbar_back_withtext" highImageName:@"navigationbar_back_withtext_highlighted" title:[[self.childViewControllers lastObject] title] target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    //[self popToRootViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES; // 默认为支持右滑反回
}

@end
