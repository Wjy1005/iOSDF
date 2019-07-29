//
//  KTabBar.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/13.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTabBar;

@protocol KTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(KTabBar *)tabBar;

@end

@interface KTabBar : UITabBar 

@property (nonatomic , weak) id<KTabBarDelegate> tabBarDelegate;
@property (nonatomic, assign, getter=isIphoneX) BOOL iphoneX;
@end
