//
//  LoginViewController.m
//  iOSDemo
//
//  Created by Javictory on 2018/11/13.
//  Copyright © 2018年 Javictory. All rights reserved.
//

#import "LoginViewController.h"
#import "KTabBarController.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *userField;
@property(nonatomic,strong) UITextField *passField;
@property(nonatomic,strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    [self.view addSubview:self.userField];
    [self.view addSubview:self.passField];
    [self.view addSubview:self.loginBtn];
    [self layoutView];
}

- (UITextField *)userField {
    if (!_userField) {
        _userField = [[UITextField alloc] init];
        _userField.delegate = self;
        _userField.textColor = [UIColor blackColor];
        //边框厚度跟颜色
        _userField.layer.borderWidth = 1;
        _userField.layer.borderColor = [UIColor grayColor].CGColor;
        //设置文本框左边的view
        _userField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
        //设置显示模式为永远显示(默认不显示)
        _userField.leftViewMode = UITextFieldViewModeAlways;
        //        _userField.placeholder = @"请输入账号";
        NSString *holderText = @"请输入账号";
        //设置placeholder
        //第一种办法
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        //颜色
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor greenColor]
                            range:NSMakeRange(0, holderText.length)];
        //字体大小
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:16]
                            range:NSMakeRange(0, holderText.length)];
        _userField.attributedPlaceholder = placeholder;
    }
    return _userField;
}

-(UITextField *)passField {
    if (!_passField) {
        _passField = [[UITextField alloc] init];
        _passField.delegate = self;
        _passField.textColor = [UIColor blackColor];
        //边框厚度跟颜色
        _passField.layer.borderWidth = 1;
        _passField.layer.borderColor = [UIColor grayColor].CGColor;
        //设置文本框左边的view
        _passField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 6, 0)];
        //设置显示模式为永远显示(默认不显示)
        _passField.leftViewMode = UITextFieldViewModeAlways;
        _passField.placeholder = @"请输入密码";
        //设置placeholder
        //第二种办法
        //颜色
        [_passField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        //字体大小
        [_passField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        
    }
    return _passField;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setBackgroundColor:[UIColor orangeColor]];
        [_loginBtn setTitle:@"登入" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(void)layoutView {
    [_userField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.userField.superview);
        make.left.mas_equalTo(self.userField.superview).mas_offset(10);
        make.right.mas_equalTo(self.userField.superview).mas_offset(-10);
        make.height.mas_offset(44);
        make.centerY.mas_equalTo(self.userField.superview).centerOffset(CGPointMake(0, -50));
    }];
    
    [_passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passField.superview);
        make.top.mas_equalTo(self.userField.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.passField.superview).mas_offset(10);
        make.right.mas_equalTo(self.passField.superview).mas_offset(-10);
        make.height.mas_offset(44);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.loginBtn.superview);
        make.top.mas_equalTo(self.passField.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.loginBtn.superview).mas_offset(10);
        make.right.mas_equalTo(self.loginBtn.superview).mas_offset(-10);
        make.height.mas_offset(44);
    }];
}
- (void)loginClick {
    NSLog(@"账号为：%@ \n密码为：%@", _userField.text, _passField.text);
    
    KTabBarController *vc = [[KTabBarController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
@end
