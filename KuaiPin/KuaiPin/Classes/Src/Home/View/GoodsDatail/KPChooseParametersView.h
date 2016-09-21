//
//  KPChooseParametersView.h
//  KuaiPin
//
//  Created by 21_xm on 16/8/31.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPChooseProductPriceView.h"
@class KPSingleParameModel, KPProductSpec, KPSpecTitle;

@interface KPChooseParametersView : UIView

@property (nonatomic, copy) void(^closeAction)();

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray <KPSingleParameModel *> *singleParameModels;

/***  不同类别下所有可能的商品组合 */
@property (nonatomic, strong) NSArray <KPProductSpec *> *productSpecList;

/***  类别名称 */
@property (nonatomic, strong) NSArray <KPSpecTitle *> *specTitles;

/***  用来存储已选择参数的模型 */
@property (nonatomic, strong) KPProductSpec *productSpec;

/***  用来传递和记录已选择的参数的模型 */
@property (nonatomic, strong) KPProductSpec *oldChooseProductSpec;

/***  已选择的商品目前的价格 */
@property (nonatomic, copy) NSString *currentPrice;

@property (nonatomic, weak) KPChooseProductPriceView *choosePriceView;

@property (nonatomic, assign) NSInteger productStorage;

@property (nonatomic, assign) BOOL hideProductAddNum;

+ (instancetype)parametersView;

@end
