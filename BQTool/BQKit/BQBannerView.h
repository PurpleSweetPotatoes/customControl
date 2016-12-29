//
//  BQBannerView.h
//  Test
//
//  Created by MAC on 16/12/19.
//  Copyright © 2016年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 如包含导航栏，导致显示不正确。需要设置控制器automaticallyAdjustsScrollViewInsets属性为NO
 需要依赖SDWebImage框架
 */
@interface BQBannerView : UIView

/**
 变化image数组资源后 需要调用reloadSource方法
 */
@property (nonatomic, strong) NSArray<NSString *> * dataSource;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<NSString *> *)dataSource;
- (void)bannerViewClickEvent:(void(^)(NSInteger index))clickBlock;
- (void)reloadSource;
@end
