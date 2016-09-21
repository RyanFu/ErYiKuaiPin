//
//  KPApplyForPayBackParam.h
//  KuaiPin
//
//  Created by 21_xm on 16/8/11.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBaseParam.h"

@interface KPApplyForPayBackParam :KPBaseParam

/**
 *  订单号
 */
@property (nonatomic, copy) NSString *orderSn;

/**
 *  产品Id
 */
@property (nonatomic, copy) NSString *productId;



@end
