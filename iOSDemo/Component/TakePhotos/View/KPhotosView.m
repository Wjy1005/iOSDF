//
//  KPhotosView.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/19.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KPhotosView.h"
#import <LFImagePickerController.h>
#import "KImageView.h"
@interface KPhotosView ()<LFImagePickerControllerDelegate>

@property(nonatomic,strong) UIImageView *addBtn;
@property(nonatomic,strong) NSMutableArray<UIImage *> *imageAry;
@property(nonatomic,strong) NSMutableArray<KImageView *> *imageViewAry;
@property(nonatomic,assign) float width;

@end

@implementation KPhotosView

-(NSMutableArray<UIImage *> *)imageAry{
    if (!_imageAry) {
        _imageAry = [NSMutableArray array];
    }
    return _imageAry;
}
-(NSMutableArray<KImageView *> *)imageViewAry{
    if (!_imageViewAry) {
        _imageViewAry = [NSMutableArray array];
    }
    return _imageViewAry;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.width = (frame.size.width - 50) / 4.0;
    }
    return self;
}
- (void)layoutSubviews{
    // 一定要调用super方法
    [super layoutSubviews];
}

- (UIImageView *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIImageView alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"icon_add_picture"]];
        _addBtn.userInteractionEnabled = YES; // 设置图片可以交互
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAddBtn)];
        [_addBtn addGestureRecognizer:tap];
        _addBtn.clipsToBounds  = YES;
        [_addBtn setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _addBtn.contentMode = UIViewContentModeScaleToFill;
    }
    return _addBtn;
}

#pragma mark -- 点击添加图片
- (void)onClickAddBtn{
    if (_maxNumber > self.imageViewAry.count - 1) {
        LFImagePickerController *imagePicker = [[LFImagePickerController alloc] initWithMaxImagesCount:self.maxNumber - self.imageViewAry.count + 1 delegate:self];
        //根据需求设置
        imagePicker.allowTakePicture = YES; //不显示拍照按钮
        imagePicker.doneBtnTitleStr = @"确定"; //最终确定按钮名称
        if (self.clickAddBtnBlock) {
            self.clickAddBtnBlock(imagePicker);
        }
        //    [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark -- 添加图片
- (void)addImageView{
    //把最后一个加号去掉
    [[self.imageViewAry lastObject] removeFromSuperview];
    [self.imageViewAry removeLastObject];
    
    NSInteger i = self.imageViewAry.count;
    NSInteger j = self.imageViewAry.count;
    for (UIImage *image in self.imageAry) {
        KImageView *view = [[KImageView alloc] initWithImage:image];
        view.tag = i;
        view.delectedImageBlock = ^(NSInteger tag) {
            [[self.imageViewAry objectAtIndex:tag] removeFromSuperview];
            [self.imageViewAry removeObjectAtIndex:tag];
            [self delImageView];
        };
        view.clickImageBlock = ^(NSInteger tag) {
            NSLog(@"点击了第%ld张图",tag);
        };
        i++;
        [self addSubview:view];
        [self.imageViewAry addObject:(KImageView *)view];
    }
    if (self.maxNumber > self.imageViewAry.count) {
        //添加最后一个加号
        [self addSubview:self.addBtn];
        [self.imageViewAry addObject:(KImageView *)self.addBtn];
    }
    
    //    [self loadViewIfNeeded];
    
    for (NSInteger i = j; i < self.imageViewAry.count; i++) {
        KImageView *imageV = self.imageViewAry[i];
        if (i == self.imageViewAry.count - 1 && i != 0) {
            [imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(self.width);
                make.height.mas_offset(self.width);
                make.top.mas_equalTo(self).mas_offset( (DSCommonMargin + self.width) * (i / 4) + DSCommonMargin);
                make.left.mas_equalTo(self).mas_offset((DSCommonMargin + self.width) * (i % 4) + DSCommonMargin);
            }];
        }else{
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(self.width);
                make.height.mas_offset(self.width);
                make.top.mas_equalTo(self).mas_offset( (DSCommonMargin + self.width) * (i / 4) + DSCommonMargin);
                make.left.mas_equalTo(self).mas_offset((DSCommonMargin + self.width) * (i % 4) + DSCommonMargin);
            }];
        }
    }
}

#pragma mark -- 删除图片
- (void)delImageView{
    //如果照片数量达到最大时被删了一张，添加加号
    if (self.imageViewAry.count == self.maxNumber - 1 && [[self.imageViewAry lastObject] class] == [KImageView class]) {
        [self addSubview:self.addBtn];
        [self.imageViewAry addObject:(KImageView *)self.addBtn];
    }
    for (NSInteger i = 0; i < self.imageViewAry.count; i++) {
        KImageView *imageV = self.imageViewAry[i];
        imageV.tag = i;
        if (i == self.maxNumber - 1 && [[self.imageViewAry lastObject] class] != [KImageView alloc]) {
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(self.width);
                make.height.mas_offset(self.width);
                make.top.mas_equalTo(self).mas_offset( (DSCommonMargin + self.width) * (i / 4) + DSCommonMargin);
                make.left.mas_equalTo(self).mas_offset((DSCommonMargin + self.width) * (i % 4) + DSCommonMargin);
            }];
        }else{
            [imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(self.width);
                make.height.mas_offset(self.width);
                make.top.mas_equalTo(self).mas_offset( (DSCommonMargin + self.width) * (i / 4) + DSCommonMargin);
                make.left.mas_equalTo(self).mas_offset((DSCommonMargin + self.width) * (i % 4) + DSCommonMargin);
            }];
        }
    }
}

#pragma mark -- 点击删除按钮
- (void)onClickDelBtn:(UITapGestureRecognizer *)sender{
    NSInteger index = [sender view].tag;
    [[self.imageViewAry objectAtIndex:index] removeFromSuperview];
    [self.imageViewAry removeObjectAtIndex:index];
    [self delImageView];
}

#pragma mark -- 设置最大张数
- (void)setMaxNumber:(NSInteger)maxNumber{
    _maxNumber = maxNumber;
    [self addImageView];
}

#pragma mark -- delegate
- (void)lf_imagePickerControllerDidCancel:(LFImagePickerController *)picker{
    NSLog(@"取消了");
}

-(void)lf_imagePickerController:(LFImagePickerController *)picker didFinishPickingResult:(NSArray<LFResultObject *> *)results{
    if ([results count] > 0) {
        [self.imageAry removeAllObjects];
        for (LFResultObject *object in results) {
            NSLog(@"%@",object.info.name);
            NSLog(@"%@",object.asset);
            if ([object isKindOfClass:[LFResultImage class]]) {
                LFResultImage *resultImage = (LFResultImage *)object;
                NSLog(@"%@",resultImage);
                [self.imageAry addObject:resultImage.originalImage];
                //                NSLog(@"%@",resultImage.originalImage);
            }
        }
        [self addImageView];
    }
}
@end
