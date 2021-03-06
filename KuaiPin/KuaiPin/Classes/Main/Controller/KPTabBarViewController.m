//
//  KPTabBarViewController.m
//  KuaiPin
//
//  Created by 21_xm on 16/4/25.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPTabBarViewController.h"
#import "KPNavigationController.h"
#import "KPHomePageViewController.h"
#import "KPCateGoryViewController.h"
#import "KPDiscoverViewController.h"
#import "KPSubsidizeViewController.h"
#import "KPLoginRegisterViewController.h"
#import "KPNewPayPwdViewController.h"
#import "KPMySelfViewController.h"


#import "AppDelegate.h"
#import "RealReachability.h"
#import "KPNetworkingStatusView.h"
#import "KPBaseParam.h"
#import <MJExtension.h>

@interface KPTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation KPTabBarViewController

#pragma mark - UITabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    if (self.selectedIndex != 3) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    if (![[KPUserManager sharedUserManager].userModel.isLogin boolValue]) {
        KPLoginRegisterViewController *vc = [KPLoginRegisterViewController new];
        KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:vc];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    }
    
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    NSAddObserver(returnHomeVc:, Noti_LoginRegistDismiss)
    NSAddObserver(showSetupPayPwdVc:, Noti_LoginSuccess)
    NSAddObserver(relogin:, Noti_Relogin)
    
    KPHomePageViewController *homeVC = [[KPHomePageViewController alloc] init];
    [self setChildViewController:homeVC title:@"首页" image:@"home_default" selectImage:@"home_hover"];

    KPCategoryViewController *cateGoryVC = [[KPCategoryViewController alloc] init];
    [self setChildViewController:cateGoryVC title:@"分类" image:@"category_default" selectImage:@"category_hover"];
    
    KPDiscoverViewController *commendVC = [[KPDiscoverViewController alloc] init];
    [self setChildViewController:commendVC title:@"发现21" image:@"find_default" selectImage:@"find_hover"];
    
    KPSubsidizeViewController *subsidizeVC = [[KPSubsidizeViewController alloc] init];
    [self setChildViewController:subsidizeVC title:@"G库" image:@"cart_default" selectImage:@"cart_hover"];

    KPMySelfViewController *mySelfView = [[KPMySelfViewController alloc] init];
    [self setChildViewController:mySelfView title:@"我的" image:@"my_default" selectImage:@"my_hover"];

}

- (BOOL)willDealloc {
    
    return YES;
}

#pragma mark - 私有方法

// 添加子控制器
- (void)setChildViewController:(UIViewController *)controller title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    controller.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];
}

// 返回首页
- (void)returnHomeVc:(NSNotification *)noti {

    WHYNSLog(@"%zd", self.selectedIndex);

    if (self.selectedIndex == 3) {
        self.selectedIndex = 0;
    }

}

// 重新登录
- (void)relogin:(NSNotification *)noti {
    KPLoginRegisterViewController *vc = [KPLoginRegisterViewController new];
    KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{

        KPNavigationController *nav = (KPNavigationController *)self.viewControllers[self.selectedIndex];
        [nav popToRootViewControllerAnimated:YES];

    }];
}

// 显示设置支付密码提示框
- (void)showSetupPayPwdVc:(NSNotification *)noti {

    if ([KPUserManager sharedUserManager].userModel.hasPayPassword.integerValue) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [KPAlertController alertControllerWithTitle:@"您还没有设置支付密码，为了您的安全，是否去设置支付密码？"
                                    cancelTitle:@"取消"
                                   defaultTitle:@"去设置"
                                        handler:^(UIAlertAction *action) {

                                            KPNewPayPwdViewController *payPwd = [KPNewPayPwdViewController new];
                                            payPwd.firstSetupPayPwd = YES;
                                            KPNavigationController *nav = [[KPNavigationController alloc] initWithRootViewController:payPwd];
                                            [weakSelf presentViewController:nav animated:YES completion:nil];

                                        }];
    
}


@end
