//
//  KPGoodsDetailInfoView.m
//  KuaiPin
//
//  Created by 21_xm on 16/8/30.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPGoodsDetailInfoView.h"
#import "KPChooseParametersView.h"
#import "KPSpecTitle.h"
#import "KPProductSpec.h"
#import "KPSingleParameModel.h"
#import "KPGoodsDetailResult.h"
#import "KPSingParamView.h"

@interface KPGoodsDetailInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (nonatomic, strong) KPChooseParametersView *paramView;

@property (nonatomic, weak) KPButton *bgView;

@property (weak, nonatomic) IBOutlet UILabel *parametersLab;

@property (nonatomic, strong) NSMutableArray *subTitles;

@property (nonatomic, strong) NSMutableArray *subTitlesId;

/***  记录当前所选商品的价格 */
@property (nonatomic, weak) NSString *currentPrice;

/***  用来传递和记录已选择的参数的模型 */
@property (nonatomic, strong) KPProductSpec *oldChooseProductSpec;


@end

@implementation KPGoodsDetailInfoView


- (NSMutableArray *)subTitles
{
    if (!_subTitles) {
        _subTitles = [NSMutableArray array];
    }
    return _subTitles;
}

- (NSMutableArray *)subTitlesId
{
    if (!_subTitlesId) {
        _subTitlesId = [NSMutableArray array];
    }
    return _subTitlesId;
}

/**
 *  参数选择的View
 */
- (KPChooseParametersView *)paramView
{
    if (_paramView == nil) {
        _paramView = [KPChooseParametersView parametersView];
        _paramView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, 407);
        
        __weak typeof (self) weakSelf = self;
        [_paramView setCloseAction:^{
            [weakSelf closeParamView];
        }];
    }
    return _paramView;
}

+ (instancetype)detailInfoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"KPGoodsDetailInfoView" owner:nil options:nil] objectAtIndex:0];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        NSAddObserver(saveSpecModel:, Noti_SaveSpecModel)
    }
    return self;
}
/**
 *  存储已选择的old的参数模型
 */
- (void)saveSpecModel:(NSNotification *)note
{
    KPProductSpec *productSpec = note.object;
    self.oldChooseProductSpec = productSpec;
}

- (void)setGoodsDetailResult:(KPGoodsDetailResult *)goodsDetailResult
{
    _goodsDetailResult = goodsDetailResult;
    self.paramView.productStorage = goodsDetailResult.productStorage.integerValue;

    if (goodsDetailResult.activity_id.integerValue && (goodsDetailResult.virginUser.integerValue == 1)) {
        self.paramView.hideProductAddNum = YES;;
    }
    
    self.title.text = goodsDetailResult.productName;
    if (self.oldChooseProductSpec) {
        self.priceLab.text = [NSString stringWithFormat:@"￥%@", self.oldChooseProductSpec.specPrice];
        self.desLab.text = [NSString stringWithFormat:@"消费即可赢得 %@ 元二一美银消费资产", self.priceLab.text];
    } else  {
        
        self.priceLab.text = [NSString stringWithFormat:@"￥%@", goodsDetailResult.productPrice];
        self.desLab.text = [NSString stringWithFormat:@"消费即可赢得 %@ 元二一美银消费资产", self.priceLab.text];
    }
}



/**
 *  选择型号点击事件
 */
- (IBAction)OpenParametersAction:(UIButton *)sender
{
    NSPostNote(Noti_ChooseProductSpec, nil)
}
// 查找无货的商品
- (void)checkNoStorageProduct
{
    switch (self.goodsDetailResult.specTitles.count) {
        case 1:
        {
            for (KPProductSpec *product in self.goodsDetailResult.productSpecList) {
                
                if (product.specStorage.integerValue == 0) {
                    WHYNSLog(@"%@", [product mj_keyValues]);
                }
            }
        }
            break;
        case 2:
        {
            for (KPProductSpec *product in self.goodsDetailResult.productSpecList) {
                
                if (product.specStorage.integerValue == 0) {
                    WHYNSLog(@"%@", [product mj_keyValues]);
                    //                    KPSingParamView *singleParamView1 = self.singParamViewArr[0];
                    //                    singleParamView1.noStorageSpec = product.spec1;
                    //                    KPSingParamView *singleParamView2 = self.singParamViewArr[1];
                    //                    singleParamView2.noStorageSpec = product.spec2;
                }
            }
            
        }
            break;
        case 3:
        {
            for (KPProductSpec *product in self.goodsDetailResult.productSpecList) {
            
                if (product.specStorage.integerValue == 0) {
//                    WHYNSLog(@"%@", [product mj_keyValues]);
                    //                    KPSingParamView *singleParamView1 = self.singParamViewArr[0];
                    //                    singleParamView1.noStorageSpec = product.spec1;
                    //                    KPSingParamView *singleParamView2 = self.singParamViewArr[1];
                    //                    singleParamView2.noStorageSpec = product.spec2;
                }
            }
        }
            break;
    }

}

// 打开型号选择器
- (void)openParamersView
{
    // 弹出选择型号模板
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    KPButton *bgView = [[KPButton alloc] init];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.backgroundColor = BlackColor;
    bgView.alpha = 0;
    [bgView addTarget:self action:@selector(closeParamView) forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    [keyWindow addSubview:self.paramView];
    
    // 执行显示动画
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.paramView.y = SCREEN_H - weakSelf.paramView.height;
        bgView.alpha = 0.4;
    }];
    
    // 给模板赋值
    switch (self.goodsDetailResult.specTitles.count) {
        case 1:
            [self setupSpecType1];
            break;
        case 2:
            [self setupSpecType2];
            break;
            
        case 3:
            [self setupSpecType3];
            break;
    }
    
    NSMutableArray *modles = [NSMutableArray array];
    
    NSUInteger titlesCount = self.goodsDetailResult.specTitles.count;
    for (int i = 0; i <titlesCount  ; i++) {
        
        KPSpecTitle *spec = self.goodsDetailResult.specTitles[i];
        
        KPSingleParameModel *model = [[KPSingleParameModel alloc] init];
        model.title = spec.spName;
        model.subTitles = self.subTitles[i];
        model.subTitlesId = self.subTitlesId[i];
        [modles addObject:model];
    }
    
    self.paramView.productSpecList = self.goodsDetailResult.productSpecList;
    self.paramView.specTitles = self.goodsDetailResult.specTitles;
    self.paramView.singleParameModels = modles;
    self.paramView.currentPrice = self.goodsDetailResult.productPrice;
    
    // 将上次选择的规格参数赋值给要显示的参数View
    if (self.oldChooseProductSpec) {
        self.paramView.oldChooseProductSpec = self.oldChooseProductSpec;
    }
    
    // 查找无货的商品
    [self checkNoStorageProduct];
    
}
/**
 *  隐藏参数页面
 */
- (void)closeParamView
{
    // 给当前价格赋值
    switch (self.goodsDetailResult.specTitles.count) {
        case 1:
            [self setupNewPriceAndParamSpecType1];
            break;
        case 2:
            [self setupNewPriceAndParamSpecType2];
            break;
            
        case 3:
            [self setupNewPriceAndParamSpecType3];
            break;
    }
    
    // 关闭参数View的动画
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.paramView.y = SCREEN_H;
        weakSelf.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [weakSelf.paramView removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
        weakSelf.paramView = nil;
        weakSelf.bgView = nil;
        
    }];
    
}

- (void)setupNewPriceAndParamSpecType1
{
    
    NSString *strSpec1 = self.paramView.productSpec.strSpec1 ? self.paramView.productSpec.strSpec1 : @"";
    if (strSpec1.length != 0) {
        
        self.parametersLab.text = [NSString stringWithFormat:@"%@", strSpec1];
        
        // 设置当前选择价格和选择规格参数
        [self setCurrentChooseParam];
    } else {
        // 设置默认价格和选择规格参数
        [self setDefaultParam];
    }
}

- (void)setupNewPriceAndParamSpecType2
{
    NSString *strSpec1 = self.paramView.productSpec.strSpec1 ? self.paramView.productSpec.strSpec1 : @"";
    NSString *strSpec2 = self.paramView.productSpec.strSpec2 ? self.paramView.productSpec.strSpec2 : @"";
    if (strSpec1.length != 0 && strSpec2.length != 0) {
        self.parametersLab.text = [NSString stringWithFormat:@"%@、%@", strSpec1, strSpec2];
        
        // 设置当前选择价格和选择规格参数
        [self setCurrentChooseParam];
    } else {
        // 设置默认价格和选择规格参数
        [self setDefaultParam];
    }
}

- (void)setupNewPriceAndParamSpecType3
{
    NSString *strSpec1 = self.paramView.productSpec.strSpec1 ? self.paramView.productSpec.strSpec1 : @"";
    NSString *strSpec2 = self.paramView.productSpec.strSpec2 ? self.paramView.productSpec.strSpec2 : @"";
    NSString *strSpec3 = self.paramView.productSpec.strSpec3 ? self.paramView.productSpec.strSpec3 : @"";
    if (strSpec1.length != 0 && strSpec2.length != 0 && strSpec3.length != 0) {
        self.parametersLab.text = [NSString stringWithFormat:@"%@、%@、%@", strSpec1, strSpec2, strSpec3];
        
        // 设置当前选择价格和选择规格参数
        [self setCurrentChooseParam];
    } else {
        // 设置默认价格和选择规格参数
        [self setDefaultParam];
    }
}
// 如果选择好了参数将当前价格和规格参数更换
- (void)setCurrentChooseParam
{
    // 设置当前价格
    self.priceLab.text = [NSString stringWithFormat:@"￥%@", self.paramView.choosePriceView.price];
    self.desLab.text = [NSString stringWithFormat:@"消费即可赢得 %@ 元二一美银消费资产", self.priceLab.text];
}
// 如果没选择就设置默认价格和规格参数
- (void)setDefaultParam
{
    self.parametersLab.text = @"请选择规格";
    self.priceLab.text = [NSString stringWithFormat:@"￥%@", self.goodsDetailResult.productPrice];
    self.desLab.text = [NSString stringWithFormat:@"消费即可赢得 %@ 元二一美银消费资产", self.priceLab.text];
}

/**
 *  有一种规格参数
 */
- (void)setupSpecType1
{
    
    NSMutableDictionary *spec1Dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.goodsDetailResult.specTitles.count ; i++) {
        
        for (KPProductSpec *productSpec in self.goodsDetailResult.productSpecList) {
            
            spec1Dict[productSpec.spec1] = productSpec.strSpec1;
        }
    }
    [self.subTitles addObject:spec1Dict.allValues];
    [self.subTitlesId addObject:spec1Dict.allKeys];
}

/**
 *  有两种规格参数
 */
- (void)setupSpecType2
{
    
    NSMutableDictionary *spec1Dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *spec2Dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.goodsDetailResult.specTitles.count ; i++) {
        
        for (KPProductSpec *productSpec in self.goodsDetailResult.productSpecList) {
            
            spec1Dict[productSpec.spec1] = productSpec.strSpec1;
            spec2Dict[productSpec.spec2] = productSpec.strSpec2;
        }
    }
    
    
    [self.subTitles addObject:spec1Dict.allValues];
    [self.subTitles addObject:spec2Dict.allValues];
    [self.subTitlesId addObject:spec1Dict.allKeys];
    [self.subTitlesId addObject:spec2Dict.allKeys];
}

/**
 *  有三种规格参数
 */
- (void)setupSpecType3
{
    
    NSMutableDictionary *spec1Dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *spec2Dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *spec3Dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.goodsDetailResult.specTitles.count ; i++) {
        
        for (KPProductSpec *productSpec in self.goodsDetailResult.productSpecList) {
            
            spec1Dict[productSpec.spec1] = productSpec.strSpec1;
            spec2Dict[productSpec.spec2] = productSpec.strSpec2;
            spec3Dict[productSpec.spec3] = productSpec.strSpec3;
        }
    }
    
    
    [self.subTitles addObject:spec1Dict.allValues];
    [self.subTitles addObject:spec2Dict.allValues];
    [self.subTitles addObject:spec3Dict.allValues];
    [self.subTitlesId addObject:spec1Dict.allKeys];
    [self.subTitlesId addObject:spec2Dict.allKeys];
    [self.subTitlesId addObject:spec3Dict.allKeys];
}

// 点击查看消费补贴详情
- (IBAction)explainBtnAction:(KPButton *)sender
{
    if (self.checkAssetExplain) {
        self.checkAssetExplain();
    }
}


- (void)dealloc
{
    NSRemoveObserver
}

@end
