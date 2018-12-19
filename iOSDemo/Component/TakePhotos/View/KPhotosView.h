//
//  KPhotosView.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/19.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LFImagePickerController;

typedef void (^clickAddBtn) (LFImagePickerController *imagePicker);
@interface KPhotosView : UIView

@property(nonatomic,copy) clickAddBtn clickAddBtnBlock;
@property(nonatomic,assign) NSInteger maxNumber;

@end
