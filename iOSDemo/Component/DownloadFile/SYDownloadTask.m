//
//  SYDownloadTask.m
//  WebView
//
//  Created by Javictory on 2019/1/11.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "SYDownloadTask.h"

@interface SYDownloadTask () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSData *downloadData;
@property (nonatomic, copy) void (^DownloadComplete)(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes);
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, assign) long long downloadBytes;
@property (nonatomic, assign) long long totalBytes;

@property (nonatomic, strong) NSURLSessionDownloadTask *dataTask;
@property (nonatomic, strong) NSURLSession *dataSession;

@end

@implementation SYDownloadTask

#pragma mark - getter

- (NSURLSession *)dataSession
{
    if (!_dataSession)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _dataSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _dataSession;
}

- (NSData *)resumeData
{
    return self.downloadData;
}

#pragma mark - 方法

/**
 *  开始下载
 *
 *  @param url      下载地址
 *  @param complete 下载回调
 */
- (void)downloadStartWithURL:(NSString *)url complete:(void (^)(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes))complete
{
    if (complete)
    {
        self.DownloadComplete = [complete copy];
    }
    
    NSURL *urlStr = [NSURL URLWithString:url];
    self.dataTask = [self.dataSession downloadTaskWithURL:urlStr];
    [self.dataTask resume];
}

/**
 *  继续下载
 *
 *  @param data     下载区域
 *  @param complete 下载回调
 */
- (void)downloadStartWithData:(NSData *)data complete:(void (^)(BOOL isFinish, NSString *filePath, long long downloadBytes, long long totalBytes))complete
{
    if (complete)
    {
        self.DownloadComplete = [complete copy];
    }
    
    self.dataTask = [self.dataSession downloadTaskWithResumeData:data];
    [self.dataTask resume];
}

/**
 *  停止，或暂停下载
 */
- (void)downloadStop
{
    __weak typeof(self) weakSelf = self;
    [self.dataTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.downloadData = resumeData;
    }];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    self.isFinish = YES;
    
    // 将文件默认下载到我们的tmp文件夹中，我们还需要将该文件移动到我们的cache当中
    NSString *destPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [destPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:fileName] error:nil];
    
    // 下载完成
    if (self.DownloadComplete)
    {
        self.DownloadComplete(self.isFinish, fileName, self.downloadBytes, self.totalBytes);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.downloadBytes = totalBytesWritten;
    self.totalBytes = totalBytesExpectedToWrite;
    
    // 正在下载
    if (self.DownloadComplete)
    {
        self.DownloadComplete(self.isFinish, nil, self.downloadBytes, self.totalBytes);
    }
}

@end
