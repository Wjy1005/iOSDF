//
//  WBVideoConfig.h
//  WebView
//
//  Created by Javictory on 2019/1/16.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 视频录制 时长
#define wbRecordTime        10.0

// 视频的长宽按比例
#define wbVideo_w_h (4.0/3)

// 视频默认 宽的分辨率  高 = kzVideoWidthPX / kzVideo_w_h
#define wbVideoWidthPX  [UIScreen mainScreen].bounds.size.height

//控制条高度 小屏幕时
#define wbControViewHeight  120.0

// 视频保存路径
#define wbVideoDicName      @"wbSmailVideo"

extern void wbdispatch_after(float time, dispatch_block_t block);

@interface WBVideoConfig : NSObject
{
    
}
+ (CGRect)viewFrame;

//  视频view的尺寸
+ (CGSize)videoViewDefaultSize;
//  默认视频分辨率
+ (CGSize)defualtVideoSize;

+ (void)showHinInfo:(NSString *)text inView:(UIView *)superView frame:(CGRect)frame timeLong:(NSTimeInterval)time;

NS_ASSUME_NONNULL_END

@end


//视频对象 Model
@interface WBVideoModel : NSObject

/// 完整视频 本地路径
@property (nonatomic, copy) NSString *videoAbsolutePath;
/// 缩略图 路径
@property (nonatomic, copy) NSString *thumAbsolutePath;
// 录制时间
//@property (nonatomic, strong) NSDate *recordTime;
@end

//录制视频
@interface WBVideoUtil : NSObject


//保存缩略图
//@param videoUrl 视频路径
//@param second   第几秒的缩略图

+ (void)saveThumImageWithVideoURL:(NSURL *)videoUrl second:(int64_t)second;

//产生新的对象
+ (WBVideoModel *)createNewVideo;


//有视频的存在
+ (BOOL)existVideo;

//  删除视频
+ (void)deleteVideo:(NSString *)videoPath;

//+ (NSString *)getVideoPath;

@end

