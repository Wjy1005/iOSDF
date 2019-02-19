//
//  WBVideoSupport.h
//  WebView
//
//  Created by Javictory on 2019/1/16.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBVideoConfig.h"
@class WBVideoModel;

//************* 点击录制的按钮 ****************
@interface WBRecordBtn : UILabel
- (instancetype)initWithFrame:(CGRect)frame;
@end

//************* 聚焦的方框 ****************
@interface WBFocusView : UIView
- (void)focusing;
@end

//************* 录视频下部的控制条 ****************
typedef NS_ENUM(NSUInteger, WBRecordCancelReason) {
    WBRecordCancelReasonDefault,
    WBRecordCancelReasonTimeShort,
    WBRecordCancelReasonUnknown,
};

@class WBControllerBar;
@protocol WBControllerBarDelegate <NSObject>
@optional

- (void)ctrollVideoDidStart:(WBControllerBar *)controllerBar;

- (void)ctrollVideoDidEnd:(WBControllerBar *)controllerBar;

- (void)ctrollVideoDidCancel:(WBControllerBar *)controllerBar reason:(WBRecordCancelReason)reason;

- (void)ctrollVideoWillCancel:(WBControllerBar *)controllerBar;

- (void)ctrollVideoDidRecordSEC:(WBControllerBar *)controllerBar;

- (void)ctrollVideoDidClose:(WBControllerBar *)controllerBar;

- (void)ctrollVideoOpenVideoList:(WBControllerBar *)controllerBar;

@end

//************* 录视频下部的控制条 ****************
@interface WBControllerBar : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<WBControllerBarDelegate> delegate;
- (void)setupSubViews;
@end

