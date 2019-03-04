//
//  SCCameraVideoViewController.h
//  RCTVideoPicker
//
//  Created by Javictory on 2019/3/4.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCameraVideoViewController : UIViewController

/**
 videofilePath：压缩后的视频在沙盒中的路径
 image：视频第一帧的图像
 */
@property(nonatomic, copy) void (^sendVideoBlock)(NSString *videofilePath, UIImage *image);

/**
 recordTime: 录制最长时间
 */
@property (nonatomic, assign) int recordTime;

@end
