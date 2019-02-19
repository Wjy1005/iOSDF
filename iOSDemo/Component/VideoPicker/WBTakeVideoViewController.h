//
//  WBTakeVideoViewController.h
//  WebView
//
//  Created by Javictory on 2019/1/16.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBVideoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TakeVideoDelegate <NSObject>
- (void)takeVideoDelegateAction:(NSString *)videoPath;
@end


@protocol WBVideoViewControllerDelegate ;

typedef void (^vedioBlock) (NSDictionary *dic);

@interface WBTakeVideoViewController : UIViewController

@property (nonatomic, assign) id<WBVideoViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL savePhotoAlbum;  // 是否保存至相册

@property (nonatomic, weak) id <TakeVideoDelegate>takeDelegate;

@property(nonatomic,copy) vedioBlock vedioBlock;        //回调数据

@end


//  录制的代理
@protocol WBVideoViewControllerDelegate <NSObject>

@required
- (void)videoViewController:(WBTakeVideoViewController *)videoController didRecordVideo:(WBVideoModel *)videoModel;  // 录制完成

@optional
- (void)videoViewControllerDidCancel:(WBTakeVideoViewController *)videoController;  // 取消

@end

NS_ASSUME_NONNULL_END
