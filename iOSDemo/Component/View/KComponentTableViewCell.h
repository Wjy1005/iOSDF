//
//  KComponentTableViewCell.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KComponentModel;
@interface KComponentTableViewCell : UITableViewCell

@property(nonatomic,strong) KComponentModel *model;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
