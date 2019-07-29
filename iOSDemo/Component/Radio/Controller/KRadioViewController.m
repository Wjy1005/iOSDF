//
//  KRadioViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/14.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KRadioViewController.h"
#import "KRadioView.h"
#import "KRadioModel.h"
@interface KRadioViewController ()

@property(nonatomic,strong) NSMutableArray *dataSourceArray;
@property(nonatomic,strong) NSMutableArray *radioViewArray;
@property(nonatomic,strong) NSMutableArray *selectedModelArray;
@property(nonatomic,strong) KRadioModel *selectedModel;

@end

@implementation KRadioViewController

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
        NSArray *array = @[
                           @{@"value":@"demo1"},
                           @{@"value":@"demo2"},
                           @{@"value":@"demo3"},
                           ];
        KRadioModel *model;
        for (NSDictionary *dic in array) {
            model = [[KRadioModel alloc] initWithDic:dic];
            [_dataSourceArray addObject:model];
        }
    }
    return _dataSourceArray;
}

-(NSMutableArray *)radioViewArray{
    if (!_radioViewArray) {
        _radioViewArray = [NSMutableArray array];
    }
    return _radioViewArray;
}
-(NSMutableArray *)selectedModelArray{
    if (!_selectedModelArray) {
        _selectedModelArray = [NSMutableArray array];
    }
    return _selectedModelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    for (KRadioModel *model in self.dataSourceArray) {
        KRadioView *radioView = [[KRadioView alloc] init];
        radioView.model = model;
        if ([model.value isEqualToString: @"demo2"]) {
            radioView.selected = YES;
        }
        __weak typeof(self) weakSelf = self;
        radioView.onClick = ^(KRadioModel *model, BOOL selected) {
            //单选
            for (KRadioView *radioView in weakSelf.radioViewArray) {
                radioView.selected = NO;
                if (selected && radioView.model == model) {
                    radioView.selected = YES;
                }
            }
            if (selected) {
                weakSelf.selectedModel = model;
            }else{
                weakSelf.selectedModel = nil;
            }
            NSLog(@"当前选中：%@",weakSelf.selectedModel);

            //多选
//            if (selected) {
//                [weakSelf.selectedModelArray addObject:model];
//            }else{
//                //判断是否有该model，避免奔溃
//                if ([weakSelf.selectedModelArray containsObject: model]) {
//                    NSInteger index = [weakSelf.selectedModelArray indexOfObject:model];
//                    [weakSelf.selectedModelArray removeObjectAtIndex:index];
//                }
//            }
//            NSLog(@"当前选中：%@",weakSelf.selectedModelArray);
        };
        [self.view addSubview:radioView];
        [self.radioViewArray addObject:radioView];
    }
    
    KRadioView *tempView;
    for (KRadioView *radioView in self.radioViewArray) {
        [radioView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(radioView.superview);
            make.height.mas_offset(44);
            if (tempView) {
                make.top.mas_equalTo(tempView.mas_bottom).mas_offset(DSCommonMargin);
            }else{
                make.top.mas_equalTo(radioView.superview).mas_offset(0);
            }
        }];
        tempView = radioView;
    }
}


@end
