//
//  WBVideoConfig.m
//  WebView
//
//  Created by Javictory on 2019/1/16.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "WBVideoConfig.h"
#import <AVFoundation/AVFoundation.h>

void wbdispatch_after(float time, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@implementation WBVideoConfig
+ (CGRect)viewFrame {
    
    return CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
}

+ (CGSize)videoViewDefaultSize {
    return CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height/2);
}
+ (CGSize)defualtVideoSize {
    return CGSizeMake(wbVideoWidthPX, wbVideoWidthPX/wbVideo_w_h);
}
+ (void)showHinInfo:(NSString *)text inView:(UIView *)superView frame:(CGRect)frame timeLong:(NSTimeInterval)time {
    __block UILabel *zoomLab = [[UILabel alloc] initWithFrame:frame];
    zoomLab.font = [UIFont boldSystemFontOfSize:15.0];
    zoomLab.text = text;
    zoomLab.textColor = [UIColor whiteColor];
    zoomLab.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:zoomLab];
    [superView bringSubviewToFront:zoomLab];
    wbdispatch_after(1.6, ^{
        [zoomLab removeFromSuperview];
    });
}
@end


@implementation WBVideoModel

+ (instancetype)modelWithPath:(NSString *)videoPath thumPath:(NSString *)thumPath recordTime:(NSDate *)recordTime {
    WBVideoModel *model = [[WBVideoModel alloc] init];
    model.videoAbsolutePath = videoPath;
    model.thumAbsolutePath = thumPath;
    return model;
}
@end


@implementation WBVideoUtil
+ (void)saveThumImageWithVideoURL:(NSURL *)videoUrl second:(int64_t)second {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:videoUrl];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    NSString *videoPath = [videoUrl.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString: @""];
    
    NSString *thumPath = [videoPath stringByReplacingOccurrencesOfString:@"MOV" withString: @"JPG"];
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:videoPath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMake(second, 10);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    if (error) {
        NSLog(@"缩略图获取失败!:%@",error);
        return;
    }
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    NSData *imgData = UIImageJPEGRepresentation(shotImage, 1.0);
    
    BOOL isok = [imgData writeToFile:thumPath atomically: YES];
    NSLog(@"缩略图获取结果:%d",isok);
    CGImageRelease(image);
    
}

+ (WBVideoModel *)createNewVideo {
    WBVideoModel *model = [WBVideoModel new];
    model.videoAbsolutePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/test.MOV"];
    model.thumAbsolutePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/test.JPG"];
    unlink([model.videoAbsolutePath UTF8String]);
    unlink([model.thumAbsolutePath UTF8String]);
    return model;
}

+ (NSString *)getDocumentSubPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:wbVideoDicName];
}


+ (void)deleteVideo:(NSString *)videoPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:videoPath error:&error];
    if (error) {
        NSLog(@"删除视频失败:%@",error);
    }
    NSString *thumPath = [videoPath stringByReplacingOccurrencesOfString:@"MOV" withString:@"JPG"];
    NSError *error2 = nil;
    [fileManager removeItemAtPath:thumPath error:&error2];
    if (error2) {
        NSLog(@"删除缩略图失败:%@",error);
    }
}
@end

