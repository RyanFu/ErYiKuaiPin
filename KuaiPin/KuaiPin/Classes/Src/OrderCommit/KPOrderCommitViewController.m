//
//  KPOrderCommitViewController.m
//  KuaiPin
//
//  Created by 王洪运 on 16/4/26.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPOrderCommitViewController.h"
#import "KPOrderCommitBottomTool.h"
#import "KPOrderCommitViewModel.h"
#import "KPAddressListViewController.h"
#import "KPOrderDetailViewController.h"
#import "KPGoodsDetailViewController.h"
#import "UINavigationBar+XM.h"
#import "KPAddressModel.h"
#import "KPOrderCreateParam.h"
#import "KPGetReceiversParam.h"
#import "KPNavigationController.h"


@interface KPOrderCommitViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) KPOrderCommitBottomTool *bottomTool;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KPOrderCommitViewModel *viewModel;

@property (nonatomic, assign) NSInteger paymentTag;

@end

@implementation KPOrderCommitViewController

- (void)setTotalPrice:(CGFloat)totalPrice {
    _totalPrice = totalPrice;
    self.viewModel.totalPrice = totalPrice;
    self.bottomTool.actualPrice = self.viewModel.actualPrice;
}

- (void)setDataModels:(NSArray *)dataModels {
    
    _dataModels = dataModels;
    
    self.viewModel.vendors = dataModels;
    
}

- (void)setDefaultReceiverModel:(id)defaultReceiverModel {
    
    _defaultReceiverModel = defaultReceiverModel;
    self.viewModel.defaultReceiver = defaultReceiverModel;
    
}

#pragma mark - 点击事件
- (void)clickBottomToolCommitBtn {
    
    __weak typeof(self) weakSelf = self;

    if (!weakSelf.viewModel.defaultReceiver) {
        [KPProgressHUD showErrorWithStatus:@"请选择默认收货人"];
        return;
    }
    
    KPOrderCreateParam *param = [KPOrderCreateParam param];
    param.ids = weakSelf.viewModel.cartItemIds;
    param.receiverId = weakSelf.viewModel.receiverId;
    param.orderMessage = weakSelf.viewModel.orderMessage;

    WHYNSLog(@"%@", [param mj_keyValues]);
    
    [KPNetworkingTool orderCreateWithParam:param success:^(id result) {
        
        NSInteger code = [result[@"code"] integerValue];
        
        if (code != 0) {
            WHYNSLog(@"%zd -- %@", code, result[@"message"]);
            [KPProgressHUD showErrorWithStatus:@"订单创建失败，等下再试吧"];
            return;
        }
        
        KPOrderDetailViewController *orderDetailVc = [KPOrderDetailViewController new];
        orderDetailVc.orderSn = result[@"data"][@"order"][@"orderSn"];
        orderDetailVc.popToRootVc = YES;
        orderDetailVc.popToSubsidizeVc = weakSelf.popToSubsidizeVc;

        [weakSelf.navigationController pushViewController:orderDetailVc animated:YES];

    } failure:^(NSError *error) {
        WHYNSLog(@"%@", error);
        [KPProgressHUD showErrorWithStatus:@"订单创建失败，等下再试吧"];
    }];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel cellForRowAtIndexPath:indexPath tableView:tableView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel heightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.viewModel viewForHeaderInSection:section tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.viewModel heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self.viewModel viewForFooterInSection:section tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.viewModel heightForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        [self pushAdressInfoViewController];
    }
    
    if (indexPath.section > 0 && indexPath.section < [tableView numberOfSections] - 2) {
        WHYNSLog(@"跳到商品详情页");
//        KPGoodsDetailViewController *goodsDetailVc = [KPGoodsDetailViewController new];
//        [self.navigationController pushViewController:goodsDetailVc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupNavigationBar];
    
    NSAddObserver(changePayment:, Noti_ChangePayment)
//    NSAddObserver(changeReceiver:, Noti_AddressChangeReceiver)

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    KPStatisticsBeginWithViewName(SelfClassStr)
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    KPStatisticsEndWithViewName(SelfClassStr)
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSRemoveObserver
    WHYNSLog(@"KPOrderCommitViewController dealloc");
}

#pragma mark - 私有方法
- (void)setupUI {
    
    self.view.backgroundColor = WhiteColor;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomTool];
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat top = 0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view).offset(top);
        make.bottom.mas_equalTo(weakSelf.bottomTool.mas_top);
    }];
    
    [self.bottomTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo([KPOrderCommitBottomTool orderCommitBottomToolHeight]);
    }];

}

- (void)setupNavigationBar {
    
    self.navigationItem.title = @"订单提交";
    
}

- (void)pushAdressInfoViewController {
    
    KPAddressListViewController *addressListVC = [KPAddressListViewController new];
    
    __weak typeof(self) weakSelf = self;
    [addressListVC setChangeReceiverHandler:^(id receiver) {
        weakSelf.defaultReceiverModel = receiver;
        [weakSelf.tableView reloadData];
    }];
    
    [self.navigationController pushViewController:addressListVC animated:YES];
    
}

- (void)changePayment:(NSNotification *)noti {
    
    if (!noti.userInfo) {
        return;
    }
    
    self.paymentTag = [noti.userInfo[PaymentTagKey] integerValue];
    
}

#pragma mark - 懒加载
- (KPOrderCommitBottomTool *)bottomTool {
    if (_bottomTool == nil) {
        __weak typeof(self) weakSelf = self;
        _bottomTool = [KPOrderCommitBottomTool orderCommitBottomToolWithCommitHandler:^{
            [weakSelf clickBottomToolCommitBtn];
        }];
    }
    return _bottomTool;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ViewBgColor;
    }
    return _tableView;
}

- (KPOrderCommitViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [KPOrderCommitViewModel sharedViewModel];
    }
    return _viewModel;
}

@end