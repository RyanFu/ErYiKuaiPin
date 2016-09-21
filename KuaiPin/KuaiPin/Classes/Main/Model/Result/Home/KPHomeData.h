//
//  KPHomeData.h
//  KuaiPin
//
//  Created by 21_xm on 16/5/24.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KPHomeModuleChannelData;
@class KPBrand, KPActivityBanner;

@interface KPHomeData : NSObject

/*** banner滚动图数组 */
@property (nonatomic, strong) NSArray *bannerList;

/*** banner滚动图数组 */
@property (nonatomic, strong) NSArray<KPBrand *> *brandList;
/*** 精品甄选 */
@property (nonatomic, strong) KPHomeModuleChannelData *selection;

@property (nonatomic, strong) KPHomeModuleChannelData *firstChannel;

@property (nonatomic, strong) NSArray *firstList;

@property (nonatomic, strong) KPHomeModuleChannelData *secondChannel;

@property (nonatomic, strong) NSArray *secondList;

@property (nonatomic, strong) KPHomeModuleChannelData *thirdChannel;

@property (nonatomic, strong) NSArray *thirdList;

@property (nonatomic, strong) KPHomeModuleChannelData *fourthChannel;

@property (nonatomic, strong) NSArray *fourthList;

@property (nonatomic, strong) NSArray<KPActivityBanner *> *activityBannerList;




/**
 *  暂时不用
 */
@property (nonatomic, strong) NSArray *brandBannerList;


@end
