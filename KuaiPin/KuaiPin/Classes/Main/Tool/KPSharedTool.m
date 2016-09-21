//
//  KPSharedTool.m
//  KuaiPin
//
//  Created by 王洪运 on 16/8/20.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPSharedTool.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import <UMSocialQQHandler.h>


NSString * const UMSocialKey = @"578467b367e58e0d96001678";
NSString * const QQAppId = @"1105626368";
NSString * const QQAppKey = @"6yJehp0Ilv1t4T0r";
NSString * const SinaAppSecret = @"279b1c06b904ddaee1da0fa5716138f1";
NSString * const SinaAppKey = @"1354153658";

@interface KPSharedTool ()<UMSocialUIDelegate>

@end

@implementation KPSharedTool

+ (void)sharedWithMessage:(NSString *)message
                    title:(NSString *)title
                   urlStr:(NSString *)urlStr
                    image:(UIImage *)image
                 imageSrc:(NSString *)imageSrc
       fromViewController:(__kindof UIViewController *)viewController {

    NSString *sharedTitle = title.length ? title : @"二一快品";
    
    message = message.length ? message : @"二一快品，用心服务中产家庭！";

    urlStr = urlStr.length ? urlStr : @"http://21kp.21my.com";

    image = image.size.height ? image : [UIImage imageNamed:@"share_placeHolder"];

    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.title = sharedTitle;
    [UMSocialData defaultData].extConfig.qqData.url = urlStr;

    [UMSocialData defaultData].extConfig.qzoneData.title = sharedTitle;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;

    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = sharedTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;

    [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;

    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@\n%@%@", sharedTitle, message, urlStr];

//    WHYNSLog(@"%@", image);
    [UMSocialSnsService presentSnsIconSheetView:viewController
                                         appKey:UMSocialKey
                                      shareText:message
                                     shareImage:image
                                shareToSnsNames:@[UMShareToSina,
                                                  UMShareToQzone,
                                                  UMShareToWechatTimeline,
                                                  UMShareToWechatSession,
                                                  UMShareToQQ]
                                       delegate:[KPSharedTool sharedTool]];

}

+ (BOOL)handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

+ (void)registSharedTool {

     //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMSocialKey];

    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WXAPPID
                            appSecret:WXAPPSecret
                                  url:@"http://21kp.21my.com"];

    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:QQAppId
                               appKey:QQAppKey
                                  url:@"http://21kp.21my.com"];

    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey
                                              secret:SinaAppSecret
                                         RedirectURL:@"21kp.21my.com"];

}

#pragma mark - UMSocialUIDelegate
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
//    if (platformName == UMShareToSina) {
//        socialData.shareText = @"分享到新浪微博的文字内容";
//    }
//    else{
//        socialData.shareText = @"分享到其他平台的文字内容";
//    }
//}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {

    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [KPProgressHUD showSuccessWithStatus:@"分享成功"];
    }

}

singleton_implementation(Tool)

@end
