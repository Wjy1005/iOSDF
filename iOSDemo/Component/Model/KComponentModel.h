//
//  KComponentModel.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KComponentModel : NSObject

@property(nonatomic,copy) NSString *title;        //标题
@property(nonatomic,copy) NSString *type;         //类型

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
