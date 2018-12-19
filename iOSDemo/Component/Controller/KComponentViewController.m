//
//  KComponentViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/13.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KComponentViewController.h"
#import "KComponentTableViewCell.h"
#import "KComponentModel.h"

#import "KRadioViewController.h"
#import "KTakePhotoViewController.h"
#import "KTakePhotosViewController.h"
#import "KImageViewController.h"
#import "KImagesViewController.h"
#import "KWeChatImagesViewController.h"
@interface KComponentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *ModelArray;

@end

@implementation KComponentViewController

-(NSMutableArray *)ModelArray {
    if (!_ModelArray) {
        _ModelArray = [NSMutableArray array];
        NSArray *array = @[
                           @{@"title":@"单选/多选",@"type":@"Radio"},
                           @{@"title":@"选择单图",@"type":@"TakePhoto"},
                           @{@"title":@"选择多图",@"type":@"TakePhotos"},
                           @{@"title":@"图片缓存、缩放",@"type":@"ImageView"},
                           @{@"title":@"轮播图",@"type":@"ImagesView"},
                           @{@"title":@"图片展示（仿微信）",@"type":@"WeChatImagesView"},
                           ];
        KComponentModel *model;
        for (NSDictionary *dic in array) {
            model = [[KComponentModel alloc] initWithDic:dic];
            [_ModelArray addObject:model];
        }
    }
    return _ModelArray;
}
-(void)viewWillAppear:(BOOL)animated{
    //手动取消选中cell效果
    //    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //遵循协议
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //分割线样式
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //修改tableFooterView,达到隐藏多余的separator效果
        //也可以隐藏自带的separator，使用自定义
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KComponentModel *model = self.ModelArray[indexPath.row];
    NSString *type = model.type;
    UIViewController *vc;
    if ([type isEqualToString:@"Radio"]) {
        vc = [[KRadioViewController alloc] init];
    }
    if ([type isEqualToString:@"TakePhoto"]) {
        vc = [[KTakePhotoViewController alloc] init];
    }
    if ([type isEqualToString:@"TakePhotos"]) {
        vc = [[KTakePhotosViewController alloc] init];
    }
    if ([type isEqualToString:@"ImageView"]) {
        vc = [[KImageViewController alloc] init];
    }
    if ([type isEqualToString:@"ImagesView"]) {
        vc = [[KImagesViewController alloc] init];
    }
    if ([type isEqualToString:@"WeChatImagesView"]) {
        vc = [[KWeChatImagesViewController alloc] init];
    }
    if ([vc class] != [UIViewController class]) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.ModelArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KComponentTableViewCell *cell = [KComponentTableViewCell cellWithTableView:tableView];
    cell.model = self.ModelArray[indexPath.row];
    //最后一行不显示分割线，适用于自定义cell
    if (indexPath.row == self.ModelArray.count-1) {
        //原理是修改偏移量，将分割线移出屏幕
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.bounds.size.width, 0, 0);
    }else{
        //设置tableView的分割线填满cell
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return cell;
}


@end
