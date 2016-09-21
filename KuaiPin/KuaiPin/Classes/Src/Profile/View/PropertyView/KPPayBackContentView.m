//
//  KPPayBackContentView.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/10.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPPayBackContentView.h"
#import "KPPayBackOrder.h"
#import "NSString+KPExtension.h"
#import "KPAlertController.h"
#import "KPApplyForPayBackParam.h"

@interface KPPayBackContentView ()
@property (nonatomic, weak) UIImageView *img;
@property (nonatomic, weak) UILabel *orderNum;
@property (nonatomic, weak) UILabel *orderBeginTime;
@property (nonatomic, weak) UILabel *commonLab;

@property (nonatomic, strong) UILabel *subsidyPriceLab;
@property (nonatomic, strong) UIImageView *finishPayBackImg;
@property (nonatomic, strong) KPButton *canPayBackBtn;

@property (nonatomic, strong) UIImageView *processingImageView;

@end
@implementation KPPayBackContentView
#pragma mark - 懒加载
- (UIImageView *)processingImageView {
    if (_processingImageView == nil) {
        _processingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prosscing"]];
        _processingImageView.hidden = YES;
    }
    return _processingImageView;
}

- (UILabel *)subsidyPriceLab
{
    if (_subsidyPriceLab == nil) {
        _subsidyPriceLab = [[UILabel alloc] init];
        _subsidyPriceLab.textAlignment = NSTextAlignmentLeft;
        _subsidyPriceLab.textColor = RedColor;
        _subsidyPriceLab.font = UIFont_15;
//        _payBackMoney.text = @"￥998.00";
    }
    return _subsidyPriceLab;
}

- (KPButton *)canPayBackBtn
{
    if (_canPayBackBtn == nil) {
        _canPayBackBtn = [[KPButton alloc] init];
        [_canPayBackBtn setBackgroundColor:OrangeColor];
        _canPayBackBtn.hidden = YES;
//        [_canPayBackBtn setBackgroundColor:GrayColor];
        _canPayBackBtn.layer.masksToBounds = YES;
        _canPayBackBtn.layer.cornerRadius = 5;
        [_canPayBackBtn setTitle:@"申请贴现" forState:UIControlStateNormal];
        [_canPayBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _canPayBackBtn.titleLabel.font = UIFont_15;
        [_canPayBackBtn addTarget:self action:@selector(canPayBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _canPayBackBtn;
}
- (UIImageView *)finishPayBackImg
{
    if (_finishPayBackImg == nil) {
        _finishPayBackImg = [[UIImageView alloc] init];
        _finishPayBackImg.image = [UIImage imageNamed:@"paybackicon"];
    }
    return _finishPayBackImg;
}
#pragma mark - 基础设置
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"tiexian"];
        [self addSubview:img];
        self.img = img;
        
        UILabel *orderNum = [UILabel addLabelWithTitle:@"" textColor:HexColor(#8a81919198a) font:UIFont_14];
        [self addSubview:orderNum];
        self.orderNum = orderNum;
        
        UILabel *orderBeginTime = [UILabel addLabelWithTitle:@"" textColor:HexColor(#8a8a8a) font:UIFont_12];
        [self addSubview:orderBeginTime];
        self.orderBeginTime = orderBeginTime;
        
        UILabel *commonLab = [UILabel addLabelWithTitle:@"" textColor:HexColor(#8a8a8a) font:UIFont_12];
        [self addSubview:commonLab];
        self.commonLab = commonLab;

        [self addSubview:self.processingImageView];
        [self addSubview:self.canPayBackBtn];
        
    }
    return self;
}

- (void)setPayBackOrder:(KPPayBackOrder *)payBackOrder
{
    __weak typeof (self) weakSelf = self;
    _payBackOrder = payBackOrder;
    
    // 设置凭证号
    self.orderNum.text = [NSString stringWithFormat:@"凭证号：%@", payBackOrder.assetsSn];
    
    // 设置订单生成时间
    self.orderBeginTime.text = [NSString stringWithFormat:@"生成时间：%@", [NSString dateStrFromTimestamp:payBackOrder.assetsAddTime withFormatter:@"yyyy年MM月dd日"]];
    
    // 设置贴现金额样式
    NSString *text = [NSString stringWithFormat:@"贴现金额：%.2f",[payBackOrder.subsidyPrice floatValue]];
    NSRange range = [text rangeOfString:@"："];
    NSString *subStr = [text substringFromIndex:range.location + 1];
    NSRange moneyRange = NSMakeRange(range.location + 1, subStr.length);
    NSMutableAttributedString *subsidyPriceAttributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [subsidyPriceAttributedText addAttributes:@{NSFontAttributeName: UIFont_15, NSForegroundColorAttributeName: RedColor} range:moneyRange];
    
    // 设置各种状态的显示方式
    switch (payBackOrder.assetsState.integerValue) {
        case -1:    // 冻结中
        case 0:     // 未贴现
        {
            if (payBackOrder.subsidyTime) {
                
                self.commonLab.text = [NSString stringWithFormat:@"贴现时间：%@",[NSString dateStrFromTimestamp:payBackOrder.subsidyTime withFormatter:@"yyyy年MM月dd日"]];
                
            } else {
                
                self.commonLab.text = @"贴现时间：订单未收货";
            }
            
            [self addSubview:self.subsidyPriceLab];
            
            self.subsidyPriceLab.text = [NSString stringWithFormat:@"%.2f",[payBackOrder.subsidyPrice floatValue]];
            [self.subsidyPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-26);
                make.centerY.mas_equalTo(weakSelf);
            }];
        }
            break;
        case 1:  // 可申请
        {
            self.commonLab.attributedText = subsidyPriceAttributedText;
            
            self.processingImageView.hidden = YES;
            self.canPayBackBtn.hidden = NO;
            
            CGSize size = SCREEN_W < 375? CGSizeMake(70, 23): CGSizeMake(90, 30);
            
            [self.canPayBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-CommonMargin);
                make.centerY.mas_equalTo(weakSelf).offset(10);
                make.size.mas_equalTo(size);
            }];
        }
            break;
        case 2:  // 待审核
        {
            self.commonLab.attributedText = subsidyPriceAttributedText;
            self.processingImageView.hidden = NO;
            self.canPayBackBtn.hidden = YES;
            
            CGSize size = iPhone5? CGSizeMake(55, 55): self.processingImageView.image.size;
            
            [self.processingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-CommonMargin);
                make.centerY.mas_equalTo(weakSelf);
                make.size.mas_equalTo(size);
            }];
            
        }
            break;
        case 3:   // 已贴现
        {
            self.commonLab.attributedText = subsidyPriceAttributedText;
            [self addSubview:self.finishPayBackImg];
            
            CGSize size = iPhone5? CGSizeMake(55, 55): self.finishPayBackImg.image.size;
            
            [self.finishPayBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf).offset(-CommonMargin);
                make.centerY.mas_equalTo(weakSelf);
                make.size.mas_equalTo(size);
            }];
        }
            break;
    }
}

// 申请贴现的点击事件
- (void)canPayBackBtnAction
{

    KPApplyForPayBackParam *param = [KPApplyForPayBackParam param];
    param.orderSn = self.payBackOrder.orderSn;
    param.productId = self.payBackOrder.productId;
    
    [KPNetworkingTool ApplyAssetsWithParam:param success:^(id result) {
        
//        NSLog(@"-=-=-=-=-=-=-=-=%@", result);
        if (CODE == 0) {
            NSString *message = @"您的资产已申请成功，我们会在两个工作日内转入您的余额。逾期未到，请联系客服。";
            
            [KPAlertController alertControllerWithTitle:@"提交结果"
                                                message:message
                                            cancelTitle:nil
                                           defaultTitle:@"确定"
                                                handler:^(UIAlertAction *action) {
                
            // 刷新订单数据
            NSPostNote(Noti_RefreshOrders, nil)
                                                    
            }];
            
        }
        
    } failure:^(NSError *error) { }];
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak typeof (self) weakSelf = self;
    
    CGSize imgSize = self.img.image.size;
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(CommonMargin + 3);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(imgSize);
    }];
    
    CGFloat orderNumH = [self.orderNum.text sizeWithAttributes:@{NSFontAttributeName: self.orderNum.font}].height;
    [self.orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.img.mas_right).offset(CommonMargin + 3);
        make.top.mas_equalTo(weakSelf).offset(CommonMargin * 2);
        make.height.mas_equalTo(orderNumH);
    }];
    
    CGFloat orderBeginTimeH = [self.orderBeginTime.text sizeWithAttributes:@{NSFontAttributeName: self.orderBeginTime.font}].height;
    [self.orderBeginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNum);
        make.centerY.mas_equalTo(weakSelf);
        make.height.mas_equalTo(orderBeginTimeH);
    }];
    

    CGFloat commonLabH = [self.commonLab.text sizeWithAttributes:@{NSFontAttributeName: self.commonLab.font}].height;
    [self.commonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.orderNum);
        make.bottom.mas_equalTo(weakSelf).offset(-CommonMargin * 2);
        make.height.mas_equalTo(commonLabH);
    }];

}

@end
