//
//  KPCertificationController.m
//  KuaiPin
//
//  Created by 王洪运 on 16/5/13.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPCertificationController.h"
#import "KPTextField.h"
#import "KPBottomButton.h"
#import "KPBankCardInputController.h"

@interface KPCertificationController ()<KPTextFieldDelegate>

@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) KPTextField *nameLB;

@property (nonatomic, strong) KPTextField *IDCardLB;

@property (nonatomic, strong) KPBottomButton *nextBtn;

@end

@implementation KPCertificationController

#pragma mark - KPTextFieldDelegate
- (BOOL)textField:(KPTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
    if (string.length == 0) return YES;
    
    if (string.isEmoji) return NO;
    
//    WHYNSLog(@"%d", string.isEmoji);
    
    NSInteger maxLength = 18;
    
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        
        if ([textField isEqual:self.nameLB]) {
            [self.IDCardLB becomeFirstResponder];
        }else {
            [self clickNextButton];
        }
        
        return NO;
    } else if(textField.text.length >= maxLength) {
        //输入的字符个数大于maxLength，则无法继续输入，返回NO表示禁止输入
        
        if ([textField isEqual:self.IDCardLB]) {
            WHYNSLog(@"输入的字符个数大于%zd，忽略输入", maxLength);
           return NO;
        }
        
    }
    
    return YES;
}



#pragma mark - 点击事件
- (void)clickNextButton {
    
    if (self.nameLB.text.length == 0) {
        [KPProgressHUD showErrorWithStatus:@"请输入您的名字"];
        return;
    }
    
    if (!self.IDCardLB.text.isNumber) {
        [KPProgressHUD showErrorWithStatus:@"请输入数字"];
        return;
    }
    
    if (self.IDCardLB.text.length != 18 && self.IDCardLB.text.length != 15) {
        [KPProgressHUD showErrorWithStatus:@"请输入15或18位身份证号"];
        return;
    }
    
    KPAddBankCardParam *param = [KPAddBankCardParam param];
    param.realName = self.nameLB.text;
    param.idCardNo = self.IDCardLB.text;
    
    KPBankCardInputController *bankCardInputVc = [KPBankCardInputController new];
    bankCardInputVc.addBankCardParam = param;
    bankCardInputVc.popToVC = self.popToVC;
    [self.navigationController pushViewController:bankCardInputVc animated:YES];
    
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupNavigationBar];
    
    [self.nameLB becomeFirstResponder];
    
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
    
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.nameLB];
    [self.view addSubview:self.IDCardLB];
    [self.view addSubview:self.nextBtn];
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat top = 64;
    CGFloat leftRight = 9;
    CGFloat tipH = 38;
    CGFloat textFieldH = 56;
    CGFloat nextTop = 80;
    CGFloat nextH = 45;
    
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(top);
        make.left.mas_equalTo(weakSelf.view).offset(leftRight);
        make.right.mas_equalTo(weakSelf.view).offset(-leftRight);
        make.height.mas_equalTo(tipH);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.tipLB.mas_bottom);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(textFieldH);
    }];
    
    [self.IDCardLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameLB.mas_bottom);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(textFieldH);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.IDCardLB.mas_bottom).offset(nextTop);
        make.left.right.mas_equalTo(weakSelf.tipLB);
        make.height.mas_equalTo(nextH);
    }];
    
}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"实名认证";
    
}

#pragma mark - 懒加载
- (UILabel *)tipLB {
    if (_tipLB == nil) {
        _tipLB = [UILabel new];
        _tipLB.font = UIFont_14;
        _tipLB.textColor = GrayColor;
        _tipLB.text = @"银行卡的绑定需要实名认证，请如实填写你的信息";
    }
    return _tipLB;
}

- (KPTextField *)nameLB {
    if (_nameLB == nil) {
        _nameLB = [KPTextField textFieldWithTitle:@"姓名" placeHolder:@"请输入真实姓名"];
        _nameLB.delegate = self;
    }
    return _nameLB;
}

- (KPTextField *)IDCardLB {
    if (_IDCardLB == nil) {
        _IDCardLB = [KPTextField textFieldWithTitle:@"身份证" placeHolder:@"请输入身份证号"];
        _IDCardLB.keyboardType = KPKeyboardTypeIDCard;
        _IDCardLB.delegate = self;
    }
    return _IDCardLB;
}

- (KPBottomButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [KPBottomButton bottomButtonWithTitle:@"下一步" imgName:nil target:self action:@selector(clickNextButton)];
        _nextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _nextBtn;
}



@end
