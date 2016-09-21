//
//  KPGoodsDetailHeaderView.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/8.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPGoodsDetailHeaderView.h"
#import "KPGoodsDetailViewController.h"
#import "KPGoodsDetailResult.h"
#import "KPSoldoutView.h"
#import "KPGoodsDetailInfoView.h"


#define ScrollView_Height  ScaleHeight(375)

@interface KPGoodsDetailHeaderView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UIImageView *detailImg;
@property (nonatomic, weak) UIView *line2;
@property (nonatomic, weak) KPGoodsDetailInfoView *infoView;

@end
@implementation KPGoodsDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)setupUI
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.currentPageIndicatorTintColor = OrangeColor;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeperatorColor;
    [self addSubview:line];
    self.line = line;
    
    KPGoodsDetailInfoView *infoView = [KPGoodsDetailInfoView detailInfoView];
    __weak typeof (self) weakSelf = self;
    [infoView setCheckAssetExplain:^{
        if (weakSelf.detailAction) {
            weakSelf.detailAction();
        }
    }];
    [self addSubview:infoView];
    self.infoView = infoView;
    
    
    UIImageView *detailImg = [[UIImageView alloc] init];
    detailImg.image = [UIImage imageNamed:@"details"];
    [self addSubview:detailImg];
    self.detailImg = detailImg;
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = SeperatorColor;
    [self addSubview:line2];
    self.line2 = line2;
    
}

- (void)openParamersView
{
    [self.infoView openParamersView];
}

- (void)closeParamView
{
    [self.infoView closeParamView];
}

- (void)setGoodsDetailResult:(KPGoodsDetailResult *)goodsDetailResult
{
    _goodsDetailResult = goodsDetailResult;
    NSUInteger count = goodsDetailResult.images.count;
    self.pageControl.numberOfPages = count;
    for (int i = 0; i < count ; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(SCREEN_W * i, 0, SCREEN_W, ScrollView_Height);
        [imgView sd_setImageWithURL:[NSURL URLWithString:goodsDetailResult.images[i][@"productImage"]] placeholderImage:[UIImage imageNamed:@"goodsDetali_Placeholder"]];
        [self.scrollView addSubview:imgView];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_W * count, 0);
    
    if (goodsDetailResult.productStorage.integerValue == 0) {
        
        CGFloat width = ScaleHeight(156);
        KPSoldoutView *soldoutView = [[KPSoldoutView alloc] init];
        soldoutView.titleFont = UIFont_24;
        soldoutView.layer.masksToBounds = YES;
        soldoutView.layer.cornerRadius = width * 0.5;
        [self addSubview:soldoutView];
        
        __weak typeof (self) weakSelf = self;
        [soldoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(weakSelf.scrollView);
            make.height.width.mas_equalTo(width);
        }];
    }
    
    // 添加规格类目
    self.infoView.goodsDetailResult = goodsDetailResult;
    
    [self layoutIfNeeded];
    CGFloat selfBottom_H = CGRectGetMaxY(self.line2.frame);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(selfBottom_H);
    }];

}

/**
 *  设置圆点的滚动
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger currentPage = scrollView.contentOffset.x / SCREEN_W;
    self.pageControl.currentPage = currentPage;
}

/**
 *  点击圆点滚动图片跟着改变
 */
- (void)changePage:(UIPageControl * )pageControl
{
    NSInteger index = pageControl.currentPage;
    CGPoint point = CGPointMake(SCREEN_W * index, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
   __weak typeof (self) weakSelf = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(ScrollView_Height);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.scrollView.mas_bottom).offset(- CommonMargin * 2);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(CommonMargin * 2);
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.scrollView.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.line.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
    }];
    
    
    [self.detailImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.infoView.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(40);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.detailImg.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];

}
@end
