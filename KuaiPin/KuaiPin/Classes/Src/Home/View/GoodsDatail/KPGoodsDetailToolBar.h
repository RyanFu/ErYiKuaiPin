//
//  KPGoodsDetailToolBar.h
//  KuaiPin
//
//  Created by 21_xm on 16/6/3.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPGoodsDetailToolBar;

@protocol KPGoodsDetailToolBarDelegate <NSObject>
/** 点击了客服按钮 */
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedServiceBtn:(KPButton *)selectedServiceBtn;
/** 点击了商铺按钮 */
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedBrandBtn:(KPButton *)selectedBrandBtn;
/** 点击了收藏按钮 */
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedCollectBtn:(KPButton *)selectedCollectBtn;
/** 点击了补贴篮按钮 */
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedGoodsCarBtn:(KPButton *)selectedGoodCarBtn;

@end
@interface KPGoodsDetailToolBar : UIView

/***  商品是否被收藏 */
@property (nonatomic, copy) NSString *isCollection;

/***  购物车商品数量 */
@property (nonatomic, copy) NSString *subsidizeBadgeValue;

/***  库存 */
@property (nonatomic, strong) NSNumber *productStorage;


@property (nonatomic, assign) id <KPGoodsDetailToolBarDelegate> delegate;

+ (instancetype)toolBar;

@end
