//
//  KPMySelfViewController.m
//  KuaiPin
//
//  Created by 21_xm on 16/8/26.
//  Copyright © 2016年 21_xm. All rights reserved.
//

// controller
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "KPMySelfViewController.h"
#import "KPNavigationController.h"
#import "KPMessageViewController.h"
#import "KPFootTraceViewController.h"
#import "KPAccountManageViewController.h"
#import "KPBaseOrderViewController.h"
#import "KPPropertyViewController.h"
#import "KPGoodsCollectionViewController.h"
#import "KPBeLeftMoneyViewController.h"
#import "KPBankCardManageController.h"
#import "KPLikeBrandViewController.h"
#import "KPLoginRegisterViewController.h"

// view
#import "KPMySelfCommonView.h"
#import "KPProfileHeaderView.h"
#import "KPMySelfKeFuView.h"
#import "KPProfileItem.h"

// model
#import "KPUploadParam.h"
#import "KPUserUpdateParam.h"
#import "KPInviteViewController.h"

@interface KPMySelfViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) KPProfileHeaderView *headerView;

@property (nonatomic, weak) KPMySelfCommonView *kuaiPin;

@end

@implementation KPMySelfViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self  setupUI];
    
    [self  setupNotification];
}

- (void)setupUI
{
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = WhiteColor;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = BaseColor;
    scrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 49);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    
    KPProfileHeaderView *headerView = [[KPProfileHeaderView alloc] init];
    headerView.width = SCREEN_W;
    headerView.height = 196;
    [scrollView addSubview:headerView];
    self.headerView = headerView;
    
    CGFloat kuaipin_Y = CGRectGetMaxY(headerView.frame);
    KPMySelfCommonView *kuaiPin = [KPMySelfCommonView commonView];
    kuaiPin.title = @"我的快品";
    kuaiPin.subTitle = @"你的消费记录都在这里";
    kuaiPin.frame = CGRectMake(0, kuaipin_Y, SCREEN_W, 109);
    kuaiPin.itemNames = @[@"待付款", @"待收货", @"已取消", @"全部"];
    [scrollView addSubview:kuaiPin];
    self.kuaiPin = kuaiPin;
    
    CGFloat meiYin_Y = CGRectGetMaxY(kuaiPin.frame) + CommonMargin;
    KPMySelfCommonView *meiYin = [KPMySelfCommonView commonView];
    meiYin.title = @"我的美银";
    meiYin.subTitle = @"零钱、消费资产还有银行卡信息";
    meiYin.frame = CGRectMake(0, meiYin_Y, SCREEN_W, 109);
    meiYin.itemNames = @[@"零钱", @"消费资产", @"银行卡", @"邀请有奖"];
    [scrollView addSubview:meiYin];
    
    CGFloat bigData_Y = CGRectGetMaxY(meiYin.frame) + CommonMargin;
    KPMySelfCommonView *bigData = [KPMySelfCommonView commonView];
    bigData.title = @"我的大数据";
    bigData.subTitle = @"收藏、关注还有看过的";
    bigData.frame = CGRectMake(0, bigData_Y, SCREEN_W, 138);
    bigData.itemNames = @[@"收藏", @"关注", @"足迹"];
    [scrollView addSubview:bigData];
    
    CGFloat keFu_Y = CGRectGetMaxY(bigData.frame) + CommonMargin;
    KPMySelfKeFuView *keFu = [KPMySelfKeFuView keFuView];
    keFu.frame = CGRectMake(0, keFu_Y, SCREEN_W, 54);
    [scrollView addSubview:keFu];
    
    scrollView.contentSize = CGSizeMake(SCREEN_W, CGRectGetMaxY(keFu.frame));
    
    // 点击了用户名
    [headerView setAccountManager:^{
        
        if (!IsLogin) {
            KPLoginRegisterViewController *loginVc = [[KPLoginRegisterViewController alloc] init];
            KPNavigationController *loginNav = [[KPNavigationController alloc] initWithRootViewController:loginVc];
            [self presentViewController:loginNav animated:YES completion:nil];
        }
        else
        {
            __weak typeof (self) weakSelf = self;
            KPAccountManageViewController *accountManageVc = [[KPAccountManageViewController alloc] init];
            accountManageVc.isLogout = ^{
                WHYNSLog(@"退出");
                weakSelf.headerView.isLogout = YES;
                
            };
            [self.navigationController pushViewController:accountManageVc animated:YES];
        }
    }];
    
    // 点击用户头像修改头像
    [headerView setChangeUserIcon:^{
        
        if (!IsLogin) {
            KPLoginRegisterViewController *loginVc = [[KPLoginRegisterViewController alloc] init];
            KPNavigationController *loginNav = [[KPNavigationController alloc] initWithRootViewController:loginVc];
            [self presentViewController:loginNav animated:YES completion:nil];
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", @"相机拍照", nil];
            [actionSheet showInView:self.view];
        }
    }];
    
    // 点击消息按钮
    [headerView setMessageBtnBlock:^{
        
        if (!IsLogin) {
            KPLoginRegisterViewController *loginVc = [[KPLoginRegisterViewController alloc] init];
            KPNavigationController *loginNav = [[KPNavigationController alloc] initWithRootViewController:loginVc];
            [self presentViewController:loginNav animated:YES completion:nil];
        }
        else
        {
            KPMessageViewController *messageVc = [KPMessageViewController sharedMessageViewController];
            [self.navigationController pushViewController:messageVc animated:YES];
        }
    }];
    
}

#pragma mark - 修改头像 - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
    }
    else if (buttonIndex == 0)
    { // 从相册选择
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    { // 调取相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *iconImage = info[UIImagePickerControllerEditedImage];
    [KPUserManager sharedUserManager].userModel.avatarImg = iconImage;
    [KPUserManager updateUser];
    NSNotification *note = [NSNotification notificationWithName:Noti_ChangeUserIconImage object:iconImage];
    [self changeIconImage:note];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 接收通知
- (void)setupNotification
{
    // 每个item点击事件
    NSAddObserver(profileItemTapAction:, Noti_ProfileItemTapAction)
    
    // 账户管理修改头像的通知
    NSAddObserver(changeIconImage:, Noti_ChangeUserIconImage)

}

// 账户管理修改头像的通知
- (void)changeIconImage:(NSNotification *)note
{
    UIImage *iconImage = note.object;
    UIImage *scaleImg = [UIImage OriginImage:iconImage scaleToSize:CGSizeMake(170, 170)];
    
    KPUploadParam *param = [KPUploadParam new];
    param.imgFileName = @"userImg.png";
    param.imgFilePath = DocumentPathWithFileName(param.imgFileName);
    param.imgData = UIImagePNGRepresentation(scaleImg);
    
    __weak typeof (self) weakSelf = self;
    
    if ([param.imgData writeToFile:param.imgFilePath atomically:YES]) {
        [KPNetworkingTool uploadUserIconWithParam:param success:^(id result) {
            
            if ([result[@"code"] integerValue] == 0) {
                NSString *avatar = [result[@"data"][@"urls"] firstObject];
                KPUserUpdateParam *param = [KPUserUpdateParam param];
                param.avatar = avatar;
                [KPNetworkingTool userUpdateWithParam:param success:^(id subResult) {
                    WHYNSLog(@"%@", subResult);
                    
                    if ([subResult[@"code"] integerValue] == 0) {
                        
                        [KPUserManager sharedUserManager].userModel.avatar = avatar;
                        [KPUserManager updateUser];
                        [KPProgressHUD showSuccessWithStatus:@"上传头像成功"];
                        // 更新头像
                        weakSelf.headerView.icon = scaleImg;
                    }
                    else
                    {
                        [KPProgressHUD showSuccessWithStatus:@"上传头像失败"];
                    }
                } failure:^(NSError *error) {
                    [KPProgressHUD showSuccessWithStatus:@"上传头像失败"];
                }];
            }
            else
            {
                [KPProgressHUD showSuccessWithStatus:@"上传头像失败"];
            }
        } failure:^(NSError *error) {
            WHYNSLog(@"%@", error);
        }];
    }
}

// 每个item点击事件
- (void)profileItemTapAction:(NSNotification *)note
{
    KPProfileItem *item = (KPProfileItem *)note.object;
    NSString *title = item.title.text;

    if ([title isEqualToString:@"邀请有奖"])
    {
        KPInviteViewController *propertyVc = [[KPInviteViewController alloc] init];
        [self.navigationController pushViewController:propertyVc animated:YES];
        return;
    }

    if (!IsLogin) {
        KPLoginRegisterViewController *loginVc = [[KPLoginRegisterViewController alloc] init];
        KPNavigationController *loginNav = [[KPNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    else
    {
        if ([title isEqualToString:@"足迹"]) {
            KPFootTraceViewController *footTarceVc = [[KPFootTraceViewController alloc] init];
            footTarceVc.title = title;
            [self.navigationController pushViewController:footTarceVc animated:YES];
        }
        else if ([title isEqualToString:@"收藏"]) {
            KPGoodsCollectionViewController *goodsCollectionVc = [[KPGoodsCollectionViewController alloc] init];
            goodsCollectionVc.title = title;
            [self.navigationController pushViewController:goodsCollectionVc animated:YES];
        }
        else if ([title isEqualToString:@"关注"]) {
            KPLikeBrandViewController *likeBrandVc = [[KPLikeBrandViewController alloc] init];
            likeBrandVc.title = title;
            [self.navigationController pushViewController:likeBrandVc animated:YES];
        }
        else if ([title isEqualToString:@"待付款"])
        {
            KPBaseOrderViewController *unPayOrderVc = [[KPBaseOrderViewController alloc] init];
            unPayOrderVc.selectedPageIndex = 0;
            [self.navigationController pushViewController:unPayOrderVc animated:YES];
        }
        else if ([title isEqualToString:@"待收货"])
        {
            KPBaseOrderViewController *unRecieveOrderVc = [[KPBaseOrderViewController alloc] init];
            unRecieveOrderVc.selectedPageIndex = 1;
            [self.navigationController pushViewController:unRecieveOrderVc animated:YES];
        }
        else if ([title isEqualToString:@"已取消"])
        {
            KPBaseOrderViewController *cancelOrderVc = [[KPBaseOrderViewController alloc] init];
            cancelOrderVc.selectedPageIndex = 2;
            [self.navigationController pushViewController:cancelOrderVc animated:YES];
        }
        else if ([title isEqualToString:@"全部"])
        {
            KPBaseOrderViewController *allOrderVc = [[KPBaseOrderViewController alloc] init];
            allOrderVc.selectedPageIndex = 4;
            [self.navigationController pushViewController:allOrderVc animated:YES];
        }
        else if ([title isEqualToString:@"零钱"])
        {
            KPBeLeftMoneyViewController *beLeftMoneyVc = [[KPBeLeftMoneyViewController alloc] init];
            beLeftMoneyVc.title = title;
            [self.navigationController pushViewController:beLeftMoneyVc animated:YES];
        }
        else if ([title isEqualToString:@"银行卡"])
        {
            KPBankCardManageController *bankCardVc = [KPBankCardManageController new];
            [self.navigationController pushViewController:bankCardVc animated:YES];
        }
        else if ([title isEqualToString:@"消费资产"])
        {
            KPPropertyViewController *propertyVc = [[KPPropertyViewController alloc] init];
            [self.navigationController pushViewController:propertyVc animated:YES];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KPStatisticsBeginWithViewName(SelfClassStr)
    
    if (IsLogin) {
        KPUserManager *userManager = [KPUserManager sharedUserManager];
        NSString *nickname = userManager.userModel.nickname;
        UIImage *icon = userManager.userModel.avatarImg;
        
        self.headerView.username = nickname.length > 0 ? nickname : @"二一快品";
        self.headerView.icon = icon ? icon : [UIImage imageNamed:@"userDefaultAvtor"];
        [self setupProfileData];
    }
    else
    {
        self.headerView.username = @"登录/注册";
        self.headerView.icon = [UIImage imageNamed:@"userDefaultAvtor"];
        self.headerView.messageBadgeValue = @"0";
        self.kuaiPin.unPayOrderNum = @"0";
        self.kuaiPin.unReceiveOrderNum = @"0";
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    KPStatisticsEndWithViewName(SelfClassStr)
}

- (void)setupProfileData
{
    __weak typeof (self) weakSelf = self;
    [KPNetworkingTool GetProfileData:^(id result) {
        
        if (CODE == 0) {
            weakSelf.kuaiPin.unPayOrderNum = [NSString stringWithFormat:@"%@", result[@"data"][@"unPayOrderNum"]];
            weakSelf.kuaiPin.unReceiveOrderNum = [NSString stringWithFormat:@"%@", result[@"data"][@"unReceiveOrderNum"]];
            weakSelf.headerView.messageBadgeValue = [NSString stringWithFormat:@"%@", result[@"data"][@"messageNum"]];
        }
        else {
            weakSelf.headerView.messageBadgeValue = @"0";
        }
        
        
    } failure:^(NSError *error) {
        weakSelf.headerView.messageBadgeValue = @"0";
    }];
}

@end
