//
//  KRadioModel.h
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRadioModel : NSObject

@property(nonatomic,strong) NSString *value;
@property(nonatomic,strong) NSString *Id;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
