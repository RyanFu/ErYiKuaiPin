//
//  KPRootVcTool.m
//  KuaiPin
//
//  Created by 21_xm on 16/5/23.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPRootVcTool.h"
#import "KPAdViewController.h"
#import "KPLeadPageViewController.h"
//#import "KPTabBarViewController.h"


@implementation KPRootVcTool


+ (void)rootVcWithKeyWindow:(UIWindow *)keyWindow
{
    // 从沙盒中取出上次存储的软件版本号(取出用户上次的使用记录)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:VersionKey];

    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    if ([currentVersion isEqualToString:lastVersion]) {// 不是新版本
        
        keyWindow.rootViewController = [[KPAdViewController alloc] init];
        
    } else {  // 新版本
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        keyWindow.rootViewController = [KPLeadPageViewController leadPage];
        
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:VersionKey];
        [defaults synchronize];
    }
}


@end