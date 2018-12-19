//
//  KRadioView.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KRadioView.h"
#import "KRadioModel.h"
@interface KRadioView()

@property(nonatomic,strong) UILabel *valueLab;
@property(nonatomic,strong) UIImageView *radioImgV;


@end

@implementation KRadioView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPress)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.radioImgV];
        [self addSubview:self.valueLab];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_radioImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(DSCommonMargin);
    }];
    [_valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.radioImgV.mas_right).mas_offset(DSCommonMargin);
    }];
}
-(UIImageView *)radioImgV{
    if (!_radioImgV) {
        _radioImgV = [[UIImageView alloc] init];
        _radioImgV.image = [UIImage imageNamed:@"icon_unselected"];
    }
    return _radioImgV;
}
-(UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc] init];
        _valueLab.textColor = DSCommonColor;
        _valueLab.font = DSCommonFont;
        _valueLab.text = @"title";
    }
    return _valueLab;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        _radioImgV.image = [UIImage imageNamed:@"icon_selected"];
    }else{
        _radioImgV.image = [UIImage imageNamed:@"icon_unselected"];
    }
}

-(void)setModel:(KRadioModel *)model{
    _model = model;
    _valueLab.text = model.value;
    _radioImgV.image = [UIImage imageNamed:@"icon_unselected"];
}

- (void)onPress {
    _selected = !_selected;
    if (_selected) {
        _radioImgV.image = [UIImage imageNamed:@"icon_selected"];
    }else{
        _radioImgV.image = [UIImage imageNamed:@"icon_unselected"];
    }
    if (self.onClick) {
        self.onClick(_model, _selected);
    }
}

@end
