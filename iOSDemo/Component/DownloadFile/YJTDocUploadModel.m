//
//  YJTDocUploadModel.m
//  WebView
//
//  Created by Javictory on 2019/1/14.
//  Copyright © 2019年 Javictory. All rights reserved.
//

#import "YJTDocUploadModel.h"

@implementation YJTDocUploadModel



// 上传完毕后更新模型相关数据
- (void)setUploadedCount:(NSInteger)uploadedCount {
    
    _uploadedCount = uploadedCount;
    
    self.uploadPercent = (float)uploadedCount / self.totalCount;
    self.progressLableText = [NSString stringWithFormat:@"%.2fMB/%.2fMB",self.totalSize * self.uploadPercent /1024.0/1024.0,self.totalSize/1024.0/1024.0];
    if (self.progressBlock) {
        self.progressBlock(self.uploadPercent,self.progressLableText);
    }
    // 刷新本地缓存
//    [[YJTUploadManager shareUploadManager] refreshCaches];
    
}


@end
