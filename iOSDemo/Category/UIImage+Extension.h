//
//  UIImage+Extension.h
//  新浪微博
//
//  Created by xc on 15/3/5.
//  Copyright (c) 2015年 xc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  争对ios7以上的系统适配新的图片资源
 *
 *  @param imageName 图片名称
 *
 *  @return 新的图片
 */
+ (UIImage *) imageWithName:(NSString *) imageName;

+ (UIImage *) resizableImageWithName:(NSString *)imageName;
/**
 *  实现图片的缩小或者放大
 *
 *  @param image 原图
 *  @param size  大小范围
 *
 *  @return 新的图片
 */
- (UIImage*) scaleImageWithSize:(CGSize)size;

/**
 *  仿微信对图片进行压缩
 *  根据图片宽高，先对宽高进行缩小，再压缩
 *
 *  @param image 原图
 *
 *  @return 新图的data
 */
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;
@end
