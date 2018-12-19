//
//  KRadioView.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KRadioModel;

typedef void (^onClick) (KRadioModel *model, BOOL selected);
@interface KRadioView : UIView

@property(nonatomic,strong) KRadioModel *model;
@property(nonatomic,strong) onClick onClick;

@property(nonatomic,assign, getter=isSelected) BOOL selected;

@end
