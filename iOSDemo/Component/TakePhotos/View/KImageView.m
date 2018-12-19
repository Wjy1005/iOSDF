//
//  KImageView.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/19.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KImageView.h"

@implementation KImageView

- (instancetype)initWithImage:(UIImage *)image{
    if (self = [super init]) {
        float witdh = (DSScreenWidth - 50) / 4.0;
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, witdh, witdh)];
        imageV.image = image;
        imageV.clipsToBounds  = YES;
        [imageV setContentScaleFactor:[[UIScreen mainScreen] scale]];
        imageV.contentMode =  UIViewContentModeScaleAspectFit;
        //删除键
        UIImageView *delBtn = [[UIImageView alloc] initWithFrame:CGRectMake(witdh - 20, 0, 20, 20)];
        [delBtn setImage:[UIImage imageNamed:@"icon_del_picture"]];
        delBtn.userInteractionEnabled = YES; // 设置图片可以交互
        UITapGestureRecognizer *delTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDelBtn)];
        [delBtn addGestureRecognizer:delTap];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        [self addSubview:imageV];
        [self addSubview:delBtn];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImageV)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)onClickDelBtn{
    if (self.delectedImageBlock) {
        self.delectedImageBlock(self.tag);
    }
}
- (void)onClickImageV{
    if (self.clickImageBlock) {
        self.clickImageBlock(self.tag);
    }
}
@end
