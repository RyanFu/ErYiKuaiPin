//
//  KPRegisterView.h
//  KuaiPin
//
//  Created by 王洪运 on 16/5/5.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NextStepHandler)(NSString *authCode, NSString *phone, BOOL agree);

typedef void(^ClickKuaiPinServeProtocolHandler)();


@interface KPRegisterView : UIView

@property (nonatomic, copy) NextStepHandler nextStepHandler;

@property (nonatomic, copy) ClickKuaiPinServeProtocolHandler clickKuaiPinServeProtocolHandler;

@property (nonatomic, copy) void(^GetAuthCodeHandler)(NSString *phone, BOOL isRetry);

@property (nonatomic, assign) BOOL hideKuaiPinServeProtocol;

@property (nonatomic, copy) NSString *nextTitle;

+ (instancetype)registerViewWithFrame:(CGRect)frame
                      nextStepHandler:(NextStepHandler)nextStepHandler
     clickKuaiPinServeProtocolHandler:(ClickKuaiPinServeProtocolHandler)clickKuaiPinServeProtocolHandler;

- (void)setGetAuthCodeButtonTitle:(NSString *)title state:(UIControlState)state;

- (void)setGetAuthCodeButtonEnabled:(BOOL)enabled;

- (void)agreeKuaiPinServeProtocol;

@end