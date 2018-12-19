//
//  KTakePhotosViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/15.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "KTakePhotosViewController.h"
#import <LFImagePickerController.h>
#import "KPhotosView.h"
@interface KTakePhotosViewController ()

@end

@implementation KTakePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    KPhotosView *photoView = [[KPhotosView alloc] initWithFrame:CGRectMake(0, 64, DSScreenWidth, 200)];
    photoView.maxNumber = 5;
    photoView.clickAddBtnBlock = ^(LFImagePickerController *imagePicker) {
        [self presentViewController:imagePicker animated:YES completion:nil];
    };
    
    [self.view addSubview:photoView];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
