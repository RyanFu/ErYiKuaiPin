//
//  KPReceiversModel.h
//  KuaiPin
//
//  Created by 王洪运 on 16/6/2.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import "KPBaseModel.h"
#import "KPAddressModel.h"

@interface KPReceiversModel : KPBaseModel

@property (nonatomic, strong) NSArray<KPAddressModel *> *receivers;

@end