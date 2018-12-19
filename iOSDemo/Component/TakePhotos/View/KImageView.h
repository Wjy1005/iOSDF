//
//  KImageView.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/19.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^delectedImage) (NSInteger tag);
typedef void (^clickImage) (NSInteger tag);
@interface KImageView : UIView

@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UIImageView *delBtn;
//@property(nonatomic,assign) NSInteger ag;          //必设，标志位
@property(nonatomic,copy) delectedImage delectedImageBlock;
@property(nonatomic,copy) clickImage clickImageBlock;

- (instancetype)initWithImage:(UIImage *)image;
@end
