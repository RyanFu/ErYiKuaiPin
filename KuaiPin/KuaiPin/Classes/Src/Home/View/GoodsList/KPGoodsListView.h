//
//  KPGoodsListView.h
//  KuaiPin
//
//  Created by 21_xm on 16/4/29.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KPProduct;
@class KPSubsidizeButton;

@interface KPGoodsListView : UIView

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, copy) NSString *subsidizeCount;

@property (nonatomic, copy) void(^refreshData)();

@property (nonatomic, copy) void(^reloadMoreData)();

@property (nonatomic, copy) void (^didSelectedItemIndex)(KPProduct *product);

@property (nonatomic, copy) void(^scrollViewContent_Y)(CGFloat content_Y);

/**
 *  是否隐藏上拉加载
 */
@property (nonatomic, assign) BOOL showEndRefreshingWithNoMoreData;

- (void)scrollToTop;

- (void)resetNoMoreData;


@end