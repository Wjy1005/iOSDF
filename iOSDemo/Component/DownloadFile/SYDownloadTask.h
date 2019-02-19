//
//  SYDownloadTask.h
//  WebView
//
//  Created by Javictory on 2019/1/11.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYDownloadTask : NSObject

/**
 *  下载区域
 */
@property (nonatomic, strong, readonly) NSData *resumeData;

/**
 *  开始下载
 *
 *  @param url      下载地址
 *  @param complete 下载回调
 */
- (void)downloadStartWithURL:(NSString *)url complete:(void (^)(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes))complete;

/**
 *  继续下载
 *
 *  @param data     下载区域
 *  @param complete 下载回调
 */
- (void)downloadStartWithData:(NSData *)data complete:(void (^)(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes))complete;

/**
 *  停止，或暂停下载
 */
- (void)downloadStop;

@end

NS_ASSUME_NONNULL_END
