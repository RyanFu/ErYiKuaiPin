//
//  KPShopHeaderView.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/6.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPShopHeaderView.h"
#import "KPShopDataResult.h"

@interface KPShopHeaderView ()

@property (nonatomic, weak) KPButton *collectBtn;
@property (nonatomic, weak) KPButton *shareBtn;
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *name;

@end
@implementation KPShopHeaderView

- (void)setCollectedBrand:(BOOL)collectedBrand {
    _collectedBrand = collectedBrand;
    self.collectBtn.selected = collectedBrand;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.image = [UIImage imageNamed:@"shop_bg"];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = WhiteColor;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"preview_default_icon"];
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *name = [UILabel addLabelWithTitle:@"二一快品" textColor:BlackColor font:UIFont_13];
    [self addSubview:name];
    self.name = name;
    
    KPButton *collectBtn = [[KPButton alloc] init];
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"follow-off"] forState:UIControlStateNormal];
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"follow-on"] forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:collectBtn];
    self.collectBtn = collectBtn;
    
    KPButton *shareBtn = [[KPButton alloc] init];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"list_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:shareBtn];
    self.shareBtn = shareBtn;
}

- (void)collectBtnAction:(KPButton *)collectBtn
{
    if (!collectBtn.selected) {
        if (self.collectStore) {
            self.collectStore(collectBtn);
        }
    }else {
        if (self.deCollectStore) {
            self.deCollectStore(collectBtn);
        }
    }

}

- (void)shareBtnAction:(KPButton *)shareBtn
{
    if (self.shareAction) {
        self.shareAction(shareBtn);
    }
}
- (void)setShopData:(KPShopDataResult *)shopData
{
    _shopData = shopData;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:shopData.storeAvatar] placeholderImage:[UIImage imageNamed:@"preview_default_icon"]];
    self.name.text = shopData.storeName;
    self.collectBtn.selected = shopData.isCollection.boolValue;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    CGFloat icon_Width = 72;
    CGFloat icon_Height = 36;
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf).offset(24);
        make.size.mas_equalTo(CGSizeMake(icon_Width, icon_Height));
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(weakSelf).offset(12);
        make.right.bottom.mas_equalTo(weakSelf).offset(-12);
    }];
    
    CGFloat name_Width = [self.name.text sizeWithAttributes:@{NSFontAttributeName: self.name.font}].width;
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.icon.mas_bottom).offset(10);
        if (name_Width > icon_Width) {
            make.left.mas_equalTo(weakSelf.icon);
        } else {
            make.centerX.mas_equalTo(weakSelf.icon.mas_centerX);
        }
    }];
    
    CGSize shareBtnSize = self.collectBtn.currentBackgroundImage.size;
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf).offset(-24);
        make.top.mas_equalTo(weakSelf).offset(30);
        make.size.mas_equalTo(shareBtnSize);
    }];
    CGSize collectBtnSize = self.collectBtn.currentBackgroundImage.size;
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.shareBtn.mas_left).offset(-18);
        make.top.mas_equalTo(weakSelf.shareBtn).offset(2);
        make.size.mas_equalTo(collectBtnSize);
    }];

}
@end
