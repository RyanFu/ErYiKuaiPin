//
//  KPAuthenticationController.m
//  KuaiPin
//
//  Created by 王洪运 on 16/5/13.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPAuthenticationController.h"
#import "KPBottomButton.h"
#import "KPPayPwdTextField.h"
#import "KPCertificationController.h"
#import "KPChangePayPwdParam.h"

@interface KPAuthenticationController ()

@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) UILabel *titleLB;

@property (nonatomic, strong) KPPayPwdTextField *payPwdTF;

@property (nonatomic, strong) KPBottomButton *nextBtn;

@property (nonatomic, copy) NSString *payPwd;

@end

@implementation KPAuthenticationController

#pragma mark - 点击事件
- (void)clickNextButton {

    if (self.payPwdTF.text.length != 6) {
        [KPProgressHUD showErrorWithStatus:@"请输入6位支付密码"];
        return;
    }
    
//    if (![self.payPwd isEqualToString:[KPUserManager sharedUserManager].userModel.payPassword]) {
//        [KPProgressHUD showErrorWithStatus:@"支付密码错误"];
//        return;
//    }
    
    KPChangePayPwdParam *param = [KPChangePayPwdParam param];
    param.payPassword = self.payPwdTF.text;
    WHYNSLog(@"%@", param.token);
    
    
    __weak typeof(self) weakSelf = self;
    [KPNetworkingTool checkPayPwdWithParam:param success:^(id result) {
        
        NSInteger code = [result[@"code"] integerValue];
        
        if (code == 10011) {
            [KPProgressHUD showErrorWithStatus:@"密码错误"];
            return;
        }
        
        if (code != 0) {
            WHYNSLog(@"%zd -- %@", code, result[@"message"]);
            return;
        }
        
        KPCertificationController *cerVc = [KPCertificationController new];
        cerVc.popToVC = weakSelf.popToVC;
        [weakSelf.navigationController pushViewController:cerVc animated:YES];
        
    } failure:^(NSError *error) {
        WHYNSLog(@"%@", error);
    }];

}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupNavigationBar];
    
    [self.payPwdTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    KPStatisticsBeginWithViewName(SelfClassStr)
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    KPStatisticsEndWithViewName(SelfClassStr)
}

#pragma mark - 私有方法
- (void)setupUI {
    
    self.view.backgroundColor = ViewBgColor;
    
    UIView *bgWhite = [UIView new];
    bgWhite.backgroundColor = WhiteColor;
    
    [self.view addSubview:self.tipLB];
    [self.view addSubview:bgWhite];
    [self.view addSubview:self.titleLB];
    [self.view addSubview:self.payPwdTF];
    [self.view addSubview:self.nextBtn];
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat top = 64;
    CGFloat leftRight = 9;
    CGFloat tipH = 38;
    CGFloat titleTop = 12;
    CGFloat titleH = 17;
    CGFloat payPwdTop = 47;
    CGFloat payPwdW = 240;
    CGFloat payPwdH = 40;
    CGFloat bgH = 100;
    CGFloat nextTop = 35;
    CGFloat nextH = 45;
    
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(top);
        make.left.mas_equalTo(weakSelf.view).offset(leftRight);
        make.right.mas_equalTo(weakSelf.view).offset(-leftRight);
        make.height.mas_equalTo(tipH);
    }];
    
    [bgWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tipLB.mas_bottom);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(bgH);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgWhite).offset(titleTop);
        make.left.mas_equalTo(weakSelf.tipLB);
        make.height.mas_equalTo(titleH);
    }];
    
    [self.payPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgWhite).offset(payPwdTop);
        make.centerX.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(payPwdW);
        make.height.mas_equalTo(payPwdH);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgWhite.mas_bottom).offset(nextTop);
        make.left.right.mas_equalTo(weakSelf.tipLB);
        make.height.mas_equalTo(nextH);
    }];
    
}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"身份验证";
    
}

#pragma mark - 懒加载
- (UILabel *)tipLB {
    if (_tipLB == nil) {
        _tipLB = [UILabel new];
        _tipLB.font = UIFont_14;
        _tipLB.textColor = GrayColor;
        _tipLB.text = @"请输入支付密码";
    }
    return _tipLB;
}

- (UILabel *)titleLB {
    if (_titleLB == nil) {
        _titleLB = [UILabel new];
        _titleLB.text = @"支付密码";
        _titleLB.font = UIFont_17;
        _titleLB.textColor = BlackColor;
    }
    return _titleLB;
}

- (KPPayPwdTextField *)payPwdTF {
    if (_payPwdTF == nil) {
        _payPwdTF = [KPPayPwdTextField new];
        __weak typeof(self) weakSelf = self;
        [_payPwdTF setInputCompletion:^(NSString *payPwd) {
            weakSelf.payPwd = payPwd;
            [weakSelf clickNextButton];
        }];
    }
    return _payPwdTF;
}

- (KPBottomButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [KPBottomButton bottomButtonWithTitle:@"下一步" imgName:nil target:self action:@selector(clickNextButton)];
        _nextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _nextBtn;
}


@end