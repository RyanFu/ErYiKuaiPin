//
//  KPLikeBrandCellContentView.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/17.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPLikeBrandCellContentView.h"
#import "KPBrand.h"

@interface KPLikeBrandCellContentView ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UILabel *likeCount;
@property (nonatomic, weak) UIImageView *arrow;
@property (nonatomic, weak) UIView *line;

@end
@implementation KPLikeBrandCellContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        
        UILabel *title = [UILabel addLabelWithTitle:@"" textColor:BlackColor font:UIFont_15];
        title.numberOfLines = 0;
        [self addSubview:title];
        self.title = title;
        
        UILabel *likeCount = [UILabel addLabelWithTitle:@"" textColor:HexColor(#8a8a8a) font:UIFont_12];
        [self addSubview:likeCount];
        self.likeCount = likeCount;
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brand_nexticon"]];
        [self addSubview:arrow];
        self.arrow = arrow;
        
        UIView *line = [UIView line];
        [self addSubview:line];
        self.line = line;
        
        
    }
    return self;
}

- (void)setBrand:(KPBrand *)brand
{
    _brand = brand;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:brand.storeAvatar] placeholderImage:[UIImage imageNamed:@"homeGoods_Placeholder"]];
    self.title.text = brand.storeName;
    self.likeCount.text = [NSString stringWithFormat:@"已有%@人关注", brand.followCount];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
 
    __weak typeof (self) weakSelf = self;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(CommonMargin);
        make.left.mas_equalTo(weakSelf).offset(CommonMargin);
        make.size.mas_equalTo(CGSizeMake(62, 62));
    }];
    
    CGFloat titleW = [self.title.text sizeWithAttributes:@{NSFontAttributeName: self.title.font}].width;
    CGFloat titleH = [self.title.text sizeWithAttributes:@{NSFontAttributeName: self.title.font}].height;
    if (titleW > self.centerX) {
        titleH = titleH * 2 + 5;
    }
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf).offset(14);
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(CommonMargin);
        make.right.mas_equalTo(weakSelf).offset(-CommonMargin * 3);
        make.height.mas_equalTo(titleH);
    }];
    
    CGFloat likeCountH = [self.likeCount.text sizeWithAttributes:@{NSFontAttributeName: self.likeCount.font}].height;
    [self.likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf).offset(-14);
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(CommonMargin);
        make.height.mas_equalTo(likeCountH);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-CommonMargin);
        make.size.mas_equalTo(weakSelf.arrow.image.size);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
}
@end
