//
//  BQBaseVc.h
//  HaoJiLaiSeller
//
//  Created by MAC on 16/11/9.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

//所有视图加载到 contentView上
@interface BQBaseVc : UIViewController
/** 底部视图 */
@property (nonatomic, readonly, strong) UIScrollView * contentView;


/**
 左侧按钮点击事件
 */
- (void)leftBarItemAction:(UIBarButtonItem *)barItem __attribute__((objc_requires_super));

- (void)HideNavgationBar;

/**
 调整contentView的显示高度
 */
- (void)layoutContentView;
/**
 当控制器有标签栏的时候调用此方法
 */
- (void)adjustHeight;

- (void)addContentViewBottom:(CGFloat)height;
@end

@interface UINavigationBar (Awesome)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;
@end
