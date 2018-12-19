//
//  KTabBarController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/13.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KTabBarController.h"
#import "KHomeViewController.h"
#import "KComponentViewController.h"
#import "KNavigationController.h"
#import "KTabBar.h"
@interface KTabBarController ()<KTabBarDelegate>

@property(nonatomic,weak) KHomeViewController *homeVc;
@property(nonatomic,weak) KComponentViewController *componentVc;


@end

@implementation KTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加所有的自控制器
    [self addAllChildVcs];
    //创建自定义tabbar
    [self addCustomTabBar];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAllChildVcs {
    KHomeViewController *homeVc = [[KHomeViewController alloc] init];
    [self addOneChildVc:homeVc title:@"首页" imageName:@"main" selectedImageName:@"main_select"];
    _homeVc = homeVc;
    
    KComponentViewController *componentVc = [[KComponentViewController alloc] init];
    [self addOneChildVc:componentVc title:@"组件" imageName:@"project" selectedImageName:@"project_select"];
    _componentVc = componentVc;
}

- (void)addCustomTabBar {
    //创建自定义tabbar
    KTabBar *customTabBar = [[KTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    
    //更换系统自带的tabbar
    [self setValue:customTabBar forKey:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    childVc.title = title;
    
    if ([childVc class] == [KComponentViewController class]) {
        childVc.navigationController.title = @"组件库";
    }
    
    //设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        //声明这张图用原图
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //添加导航控制器
    KNavigationController *nav = [[KNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


/**
 *  默认只调用该功能一次
 */
+ (void)initialize
{
    //设置底部tabbar的主题样式
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:DSCommonColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}

#pragma mark - DSTabBarDelegate
- (void)tabBarDidClickedPlusButton:(KTabBar *)tabBar
{
    NSLog(@"点击中间加号");
}


@end








