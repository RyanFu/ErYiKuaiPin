//
//  KPPayBackDetailHeaderTopView.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/11.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPPayBackDetailHeaderTopView.h"
#import "KPPayBackOrder.h"

@interface KPPayBackDetailHeaderTopView ()

@property (nonatomic, strong) NSMutableArray *titleTexeLabs;
@property (nonatomic, strong) NSMutableArray <UILabel *> *titleValues;

@property (nonatomic, weak) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *payBackStateView;

@end
@implementation KPPayBackDetailHeaderTopView

- (NSMutableArray *)titleValues
{
    if (_titleValues == nil) {
        _titleValues = [NSMutableArray array];
    }
    return _titleValues;
}
- (NSMutableArray *)titleTexeLabs
{
    if (_titleTexeLabs == nil) {
        _titleTexeLabs = [NSMutableArray array];
    }
    return _titleTexeLabs;
}

- (UIImageView *)payBackStateView
{
    if (_payBackStateView == nil) {
        _payBackStateView = [[UIImageView alloc] init];
    }
    return _payBackStateView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WhiteColor;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"paybackDetail"];
        [self addSubview:imgView];
        self.imgView = imgView;
        
        NSArray *titleTexts = @[@"消费资产凭证号：",@"消费资产订单号：", @"生成时间：", @"贴现时间：", @"消费资产：", @"贴现账号："];
//        NSArray *titleTexts = @[@"消费资产凭证号：", @"生成时间：", @"贴现时间：", @"消费资产：", @"贴现账号：", @"申请时间："];
        for (int i = 0; i < titleTexts.count ; i++) {
            UILabel *titleText = [UILabel addLabelWithTitle:titleTexts[i] textColor:HexColor(#8a8a8a) font:UIFont_12];
            [self addSubview:titleText];
            [self.titleTexeLabs addObject:titleText];
            
            UILabel *titleValue = [UILabel addLabelWithTitle:nil textColor:BlackColor font:UIFont_12];;
            [self addSubview:titleValue];
            [self.titleValues addObject:titleValue];
        }
    }
    return self;
}

- (void)setPayBackOrderDetail:(KPPayBackOrder *)payBackOrderDetail
{
    _payBackOrderDetail = payBackOrderDetail;
    
    // 凭证号
    self.titleValues[0].text = payBackOrderDetail.assetsSn;
    // 订单号
    self.titleValues[1].text = payBackOrderDetail.orderSn;
    
    // 生成时间
    self.titleValues[2].text = [NSString dateStrFromTimestamp:payBackOrderDetail.assetsAddTime withFormatter:@"yyyy年MM月dd"];
    
    // 贴现时间
    if (payBackOrderDetail.subsidyTime) {
        self.titleValues[3].text = [NSString dateStrFromTimestamp:payBackOrderDetail.subsidyTime withFormatter:@"yyyy年MM月dd"];
    } else {
        self.titleValues[3].text = @"订单未收货";
    }
    
    // 消费资产金额
    self.titleValues[4].text = [NSString stringWithFormat:@"%.2f", [payBackOrderDetail.subsidyPrice floatValue]];
    
    // 贴现账号
    self.titleValues[5].text = [payBackOrderDetail.username phoneSecurityString];
    
    // 申请时间
    if (payBackOrderDetail.assetsState.integerValue == 2 || payBackOrderDetail.assetsState.integerValue == 3) {
        
        UILabel *titleText = [UILabel addLabelWithTitle:@"申请时间：" textColor:HexColor(#8a8a8a) font:UIFont_12];
        [self addSubview:titleText];
        [self.titleTexeLabs addObject:titleText];
        
        UILabel *titleValue = [UILabel addLabelWithTitle:[NSString dateStrFromTimestamp:payBackOrderDetail.discountApplicationTime withFormatter:@"yyyy年MM月dd"] textColor:BlackColor font:UIFont_12];;
        [self addSubview:titleValue];
        [self.titleValues addObject:titleValue];
        
        
        if (payBackOrderDetail.assetsState.integerValue == 2) { // 待审核
            
            [self addSubview:self.payBackStateView];
            self.payBackStateView.image = [UIImage imageNamed:@"processing"];
            
            
        } else if (payBackOrderDetail.assetsState.integerValue == 3) { // 已贴现
            
            [self addSubview:self.payBackStateView];
            self.payBackStateView.image = [UIImage imageNamed:@"discount"];
        }
        
        __weak typeof (self) weakSelf = self;
        CGFloat right = SCREEN_W < 375? -9: -18;
        
        [self.payBackStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf).offset(ScaleHeight(122));
            make.right.mas_equalTo(weakSelf).offset(right);
            make.size.mas_equalTo(weakSelf.payBackStateView.image.size);
        }];
    
}
    
    
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.titleTexeLabs.count;
    
    CGFloat imgViewH = ScaleHeight(122);
    CGFloat MaxY = (self.height - imgViewH) / count;
    CGFloat titleTextW = 97;
    CGFloat titleValueW = 200;
    CGFloat titleTextMaxX = CommonMargin + titleTextW;
    
    self.imgView.frame = CGRectMake(0, 0, SCREEN_W, imgViewH);
    
    for (int i = 0; i < count; i++) {
        UILabel *titleText = self.titleTexeLabs[i];
        UILabel *titleValue = self.titleValues[i];
        titleText.frame = CGRectMake(CommonMargin,imgViewH + MaxY * i, titleTextW, MaxY);
        titleValue.frame = CGRectMake(titleTextMaxX,imgViewH + MaxY * i, titleValueW, MaxY);
    }
    
}

@end
