//
//  KPGoodsDetailViewController.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/8.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "KPGoodsDetailViewController.h"
#import "UINavigationBar+XM.h"
#import "KPBrandViewController.h"
#import "KPSubsidizeViewController.h"
#import "KPLoginRegisterViewController.h"

// View
#import "KPGoodsDetailHeaderView.h"
#import "KPCommonNavigationBar.h"
#import "KPGoodsDetailToolBar.h"

// Model
#import "KPGoodsDetailParam.h"
#import "KPGoodsDetailResult.h"
#import "KPCollectGoodsParam.h"
#import "KPUpdateSubsidizeParam.h"

#import "KPDatabase.h"
#import "KPActivityWebViewController.h"

#import "KPProduct.h"
#import "KPBrand.h"
#import "KPNavigationController.h"
#import "KPSharedTool.h"

@interface KPGoodsDetailViewController ()<KPGoodsDetailToolBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) KPGoodsDetailResult *goodsDetailResult;
@property (nonatomic, weak) KPCommonNavigationBar *commonNavigationBar;
@property (nonatomic, weak) KPGoodsDetailHeaderView *headerView;
@property (nonatomic, weak) KPGoodsDetailToolBar *toolBar;
@property (nonatomic, weak) KPButton *topBtn;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) KPActivityWebViewController *webViewVc;

@property (nonatomic, assign) BOOL showedOldUserError;

@end

@implementation KPGoodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品详情";
    
    // 添加table
    [self setupUI];
    
    // 添加bottomBtns
    [self setupBottomViews];
    
    // 改变视图控制器的背景颜色
    [self setupNavigationBar];
    
}
#pragma mark - 添加setupData
- (void)setupData
{
    
    KPGoodsDetailParam *param = [[KPGoodsDetailParam alloc] init];
    param.productId = self.product.productId;
    param.activity_id = self.activity_id;
    param.virginUser = self.virginUser;
//    param.productId = @(3675);
    WHYNSLog(@"%@", [param mj_keyValues]);
    __weak typeof (self) weakSelf = self;
    
    [KPNetworkingTool goodsDetailWithParam:param success:^(id result) {
        
//        WHYNSLog(@"%@", result);12
        if (CODE == 0) {
            weakSelf.goodsDetailResult = [KPGoodsDetailResult mj_objectWithKeyValues:result[@"data"][@"product"]];
            weakSelf.goodsDetailResult.activity_id = weakSelf.activity_id;
            weakSelf.goodsDetailResult.virginUser = weakSelf.virginUser;

            if ((weakSelf.virginUser.integerValue == 1) && (weakSelf.goodsDetailResult.isNewUser.integerValue != 1)) {
                if (!weakSelf.showedOldUserError) {
                    [KPProgressHUD showErrorWithStatus:@"对不起，您已经购买过商品，无法享受新手特权了。"];
                }
            }

            weakSelf.headerView.goodsDetailResult = weakSelf.goodsDetailResult;
            weakSelf.toolBar.isCollection = weakSelf.goodsDetailResult.isCollection;
            weakSelf.toolBar.productStorage = weakSelf.goodsDetailResult.productStorage;
            
            [weakSelf.webViewVc loadGoodDetailWithURLStr:weakSelf.goodsDetailResult.mobileBody completion:^(CGFloat webViewH) {
                
                CGFloat y = CGRectGetMaxY(weakSelf.headerView.frame);
//                    WHYNSLog(@"%@", weakSelf.headerView);
                weakSelf.webViewVc.view.frame = CGRectMake(0, y, SCREEN_W, webViewH);
                weakSelf.scrollView.contentSize = CGSizeMake(SCREEN_W, y + webViewH);
            }];

            // 本地存储
            [[KPDatabase sharedDatabase] saveData:result[@"data"][@"product"]];
            
        }
        
    } failure:^(NSError *error) {
        WHYNSLog(@"%@", error);
    }];
}

// 获取购物车商品数量
- (void)setupSubsidizeCount
{
    __weak typeof (self) weakSelf = self;
    [KPNetworkingTool getCarItemCountSuccess:^(id result) {
        
        if (CODE != 0) return;
        
        NSString *bageValue = [NSString stringWithFormat:@"%@", result[@"data"][@"cartItemCount"]];
        
        weakSelf.toolBar.subsidizeBadgeValue = bageValue;
        
        UIViewController *tabBarVc = [UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *vc = tabBarVc.childViewControllers[3];
        
        if ([bageValue isEqualToString:@"0"]) {
            vc.tabBarItem.badgeValue = nil;
        } else  {
            vc.tabBarItem.badgeValue = bageValue;
        }
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 添加NavigationBar
- (void)setupNavigationBar
{
    self.fd_prefersNavigationBarHidden = YES;
    __weak typeof(self) weakSelf = self;
    KPCommonNavigationBar *commonNavigationBar = [KPCommonNavigationBar navigationBar];
    commonNavigationBar.navigationBarType = KPCommonNavigationBarTypeGoodsDetail;
    commonNavigationBar.leftBtnAction = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:commonNavigationBar];
    self.commonNavigationBar = commonNavigationBar;
    
    
    commonNavigationBar.rightBtnAction = ^{
        
        NSString *key = weakSelf.goodsDetailResult.images.firstObject[@"productImage"];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
        
        [KPSharedTool sharedWithMessage:weakSelf.goodsDetailResult.productJingle
                                  title:weakSelf.goodsDetailResult.productName
                                 urlStr:@"http://app.21my.com/share/download/136"
                                  image:image
                               imageSrc:nil
                     fromViewController:weakSelf];
        
        // 统计每个用户分享每个product的次数
        NSString *username = [KPUserManager sharedUserManager].userModel.username;
        NSString *label = [NSString stringWithFormat:@"用户：%@ 分享了商品：%@/productId:%@", username, self.product.productName, self.product.productId];
        [KPStatisticsTool event:@"product_share_id" label:label];
    };
    
    [commonNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(64);
    }];
    
    [commonNavigationBar setBarBackgroundColorWithColor:ClearColor];
    
    
}

#pragma mark - 添加UI
- (void)setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 49);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    __weak typeof (self) weakSelf = self;
    KPGoodsDetailHeaderView *headerView = [[KPGoodsDetailHeaderView alloc] init];
    headerView.detailAction = ^{
        KPActivityWebViewController *webViewVc = [[KPActivityWebViewController alloc] init];
        webViewVc.urlStr = @"http://21kp.21my.com/zcsm/kp.html";
        webViewVc.title = @"说明";
        [weakSelf.navigationController pushViewController:webViewVc animated:YES];
        
    };

    [scrollView addSubview:headerView];
    self.headerView = headerView;
    
    CGFloat headerView_H = ScaleHeight(550);
    if (iPhone5) {
        headerView_H = ScaleHeight(590);
    }
    else if (iPhone6) {
        headerView_H = ScaleHeight(570);
    }
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollView);
        make.width.mas_equalTo(SCREEN_W);
        make.height.mas_equalTo(headerView_H);
    }];
    
    self.webViewVc = [KPActivityWebViewController new];
    [self addChildViewController:self.webViewVc];
    [scrollView addSubview:self.webViewVc.view];
    
    // 给webView和scrollView的contentsize设置初值
    self.webViewVc.view.frame = CGRectMake(0, headerView_H, SCREEN_W, 500);
    weakSelf.scrollView.contentSize = CGSizeMake(SCREEN_W, SCREEN_H);
    
}

- (void)setupBottomViews
{
    // 添加滚回按钮和购物车按钮
    KPButton *topBtn = [[KPButton alloc] init];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"backtotop"] forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(scrolToTop:) forControlEvents:UIControlEventTouchDown];
    topBtn.hidden = YES;
    [self.view addSubview:topBtn];
    self.topBtn = topBtn;
    
    KPGoodsDetailToolBar *toolBar = [KPGoodsDetailToolBar toolBar];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    __weak __typeof(self) weakSelf = self;
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(49);
    }];
    
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-CommonMargin);
        make.bottom.mas_equalTo(toolBar.mas_top).offset(-CommonMargin * 2);
        make.size.mas_equalTo(weakSelf.topBtn.currentBackgroundImage.size);
    }];
}

// 滚动到页面顶端
- (void)scrolToTop:(KPButton *)topBtn
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

// 设置导航栏显示与否
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![self.navigationController.topViewController isEqual:self]) return;
    CGFloat y = scrollView.contentOffset.y;
    CGFloat alpha = y/200;
    CGFloat max = 0.95;
    alpha = (alpha >= max)?max:alpha;
    // 改变视图控制器的背景颜色
    [self.commonNavigationBar setBarBackgroundColorWithColor:[HexColor(#f8f8f8) colorWithAlphaComponent:alpha]];
    
    // 设置title文字显示的时机
    if (SCREEN_W > 320 ? y<ScaleHeight(490)-150 : y<ScaleHeight(515)-150)
    { self.commonNavigationBar.titleView.text = nil; }  else
    { self.commonNavigationBar.titleView.text = @"商品详情"; }
    
    // 设置回滚按钮的显示
    if (y > SCREEN_H) { self.topBtn.hidden = NO; } else { self.topBtn.hidden = YES; }
}

#pragma mark - KPGoodsDetailToolBarDelegate
// 点击了客服按钮
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedServiceBtn:(KPButton *)selectedServiceBtn
{
    [KPAlertController alertActionSheetControllerWithTitle:@"拨号"
                                               cancelTitle:@"取消"
                                              defaultTitle:@"400-9921-365"
                                                   handler:^(UIAlertAction *action) {
                                                       WHYNSLog(@"拨打人工客服");
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4009-921-365"]];
                                                   }];
}
// 点击了品牌按钮
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedBrandBtn:(KPButton *)selectedBrandBtn
{
    KPBrandViewController *shopVc = [[KPBrandViewController alloc] init];
    KPBrand *brand = [[KPBrand alloc] init];
    brand.brandId = self.goodsDetailResult.brandId;
    shopVc.brand = brand;
    
    [self.navigationController pushViewController:shopVc animated:YES];
}
// 点击了收藏按钮
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedCollectBtn:(KPButton *)selectedCollectBtn
{
    if (!IsLogin) {
        
        KPLoginRegisterViewController *logVc = [[KPLoginRegisterViewController alloc] init];
        KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:logVc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } else {
        
        KPCollectGoodsParam *param = [[KPCollectGoodsParam alloc] init];
        param.productId = self.product.productId;
        
        [KPNetworkingTool CollectProduct:param Success:^(id result) {
            
            if (CODE == 0) {
                
                if ([result[@"data"][@"collect"] integerValue] == 1) {
                    
                    [KPProgressHUD showSuccessWithStatus:@"收藏成功"];
                    selectedCollectBtn.selected = YES;
                    
                } else {
                    
                    [KPProgressHUD showSuccessWithStatus:@"取消收藏"];
                    selectedCollectBtn.selected = NO;
                }
            }
        } failure:^(NSError *error) { }];
    }
}

// 点击了G库
- (void)goodsDetailToolBar:(KPGoodsDetailToolBar *)toolBar didSelectedGoodsCarBtn:(KPButton *)selectedGoodCarBtn
{
    
    if (!IsLogin) {
        KPLoginRegisterViewController *logVc = [[KPLoginRegisterViewController alloc] init];
        KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:logVc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        KPSubsidizeViewController *subSidizeVc = [[KPSubsidizeViewController alloc] init];
        [self.navigationController pushViewController:subSidizeVc animated:YES];
    }
}
// 点击了加入商品到G库
- (void)addToSubsidize:(NSNotification *)note
{
    
    if (!IsLogin) {
        KPLoginRegisterViewController *logVc = [[KPLoginRegisterViewController alloc] init];
        KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:logVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if ((self.virginUser.integerValue == 1) && (self.goodsDetailResult.isNewUser.integerValue != 1)) {
        [KPProgressHUD showErrorWithStatus:@"对不起，您已经购买过商品，无法享受新手特权了。"];
        return;
    }

    __weak typeof (self) weakSelf = self;
    KPUpdateSubsidizeParam *parm = (KPUpdateSubsidizeParam *)note.object;
    parm.productId = self.product.productId;
    parm.activity_id = self.activity_id;
    parm.virginUser = self.virginUser;

    if (self.activity_id.integerValue && (self.virginUser.integerValue == 1)) {
        parm.addAmount = @"1";
    }

    WHYNSLog(@"%@", [parm mj_keyValues]);
    [KPNetworkingTool cartUpdateWithParam:parm success:^(id result) {
        
        WHYNSLog(@"%@", result);
        if (CODE == 0)
        {
            NSString *msg = result[@"data"][@"msg"];
            if (msg.integerValue == 1) {
                [KPProgressHUD showErrorWithStatus:@"您的G库中已有特权商品，无法再次加入特权商品"];
                return;
            }

            [KPProgressHUD showSuccessWithStatus:@"加入G库成功"];
            [weakSelf setupSubsidizeCount];
            [weakSelf closeParamView];

        }else {
            [KPProgressHUD showErrorWithStatus:@"加入G库失败,请重新尝试"];
        }
    } failure:^(NSError *error) {
        WHYNSLog(@"%@", error);
        [KPProgressHUD showErrorWithStatus:@"加入G库失败,请重新尝试"];
    }];

}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KPStatisticsBeginWithViewName(SelfClassStr)
    // 统计每个品牌被点击的次数
    NSString *label = [NSString stringWithFormat:@"商品：%@,productId:%@",self.product.productName, self.product.productId];
    [KPStatisticsTool event:@"product_id" label:label];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 加载数据
    [self setupData];
    
    // 加载购物车数量
    [self setupSubsidizeCount];
    
    
    NSAddObserver(openParamersView, Noti_ChooseProductSpec)
    
    NSAddObserver(addToSubsidize:, Noti_AddToSubsidizeParam)
}

- (void)openParamersView
{
    if (self.goodsDetailResult.productStorage.integerValue != 0) {
        [self.headerView openParamersView];
    }
}

- (void)closeParamView
{
    [self.headerView closeParamView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    KPStatisticsEndWithViewName(SelfClassStr)
    
    NSRemoveObserver
}

- (BOOL)willDealloc
{
    return NO;
}
@end
