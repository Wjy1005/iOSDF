//
//  KComponentTableViewCell.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KComponentTableViewCell.h"
#import "KComponentModel.h"
@interface KComponentTableViewCell()

@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIImageView *arrowImg;


@end
@implementation KComponentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    //static,静态区局变量，只需要创建一次，程序退出时释放
    static NSString *Id = @"componentCell";
    //去tableView重用队列里取重用标识符为“Cyclecell”的cell
    KComponentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    //cell == nil  当cell为空时，也就是重用队列里没有可用的cell，那么就创建一个新的cell
    if (!cell) {
        /**
         *  UITableViewCellStyleDefault(左边一张图，一个标题)
         *  UITableViewCellStyleValue1（左边一张图 一个主题，右边副主题）
         *  UITableViewCellStyleValue2（一个主题一个副主题）
         *  UITableViewCellStyleSubtitle（一张图，一个主题，一个副主题（副主题在主题下面））
         */
        //切记，这里不能重新创建，而是继续使用上面创建好的cell
        //重用队列里没有可用的cell，重建一个，然后把新建的cell的重用标识符设置为上边定义的重用标示符
        cell = [[KComponentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    //设置tableView的分割线填满cell
//    cell.separatorInset = UIEdgeInsetsZero;
//    cell.layoutMargins = UIEdgeInsetsZero;
    //设置tableViewCell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //自定义颜色
//    cell.selectedBackgroundView = [UIView new];
//    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.arrowImg];
        [self layout];
        //cell设置
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        
        //self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
    
}

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = DSCommonColor;
        _titleLab.font = DSCommonFont;
    }
    return _titleLab;
}
-(UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"icon_right_arrow"];
    }
    return _arrowImg;
}
-(void)layout {
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab.superview);
        make.left.mas_equalTo(self.titleLab.superview.mas_left).mas_offset(DSCommonMargin);
        make.height.mas_offset(44);
        make.width.mas_offset(100);
    }];
    [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.arrowImg.superview);
        make.right.mas_equalTo(self.arrowImg.superview.mas_right).mas_offset(-DSCommonMargin);
        make.height.mas_offset(20);
        make.width.mas_offset(20);
    }];
}

-(void)setModel:(KComponentModel *)model{
    _model = model;
    _titleLab.text = model.title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
