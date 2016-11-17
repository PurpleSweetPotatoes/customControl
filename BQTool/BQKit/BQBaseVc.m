//
//  BQBaseVc.m
//  HaoJiLaiSeller
//
//  Created by MAC on 16/11/9.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BQBaseVc.h"
#import <objc/runtime.h>

#define AppMainColor [UIColor cyanColor]

@interface BQBaseVc ()
/** 底部视图 */
@property (nonatomic, strong) UIScrollView * contentView;
/** 是否隐藏导航栏 */
@property (nonatomic, assign) BOOL  isHideBar;
/** 增加显示视图滚动高度 */
@property (nonatomic, assign) CGFloat  addHeight;
@end

@implementation BQBaseVc

#pragma mark - Live Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isHideBar = NO;
    self.addHeight = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, width, height - 64)];
    self.contentView.bounces = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.contentView];
    self.contentView.contentSize = self.contentView.bounds.size;
    //返回按钮
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
    //主题色
    [self.navigationController.navigationBar lt_setBackgroundColor:AppMainColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isHideBar == YES) {
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    [self layoutContentView];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isHideBar == YES) {
        [self.navigationController.navigationBar lt_setBackgroundColor:AppMainColor];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - instancetype Method
- (void)HideNavgationBar {
    self.contentView.frame = self.view.bounds;
    self.isHideBar = YES;
}
- (void)adjustHeight {
    CGRect frame = self.contentView.frame;
    frame.size.height -= 49;
    self.contentView.frame = frame;
}
- (void)addContentViewBottom:(CGFloat)height {
    self.addHeight = height;
}
- (void)layoutContentView {
    CGFloat contentHeight = 0;
    NSArray * subViews = self.contentView.subviews;
    for (UIView * view in subViews) {
        if (CGRectGetMaxY(view.frame) > contentHeight) {
            contentHeight = CGRectGetMaxY(view.frame);
        }
    }
    contentHeight += self.addHeight;
    self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height > contentHeight ? self.contentView.bounds.size.height : contentHeight);
}
#pragma mark - Btn Action
- (void)leftBarItemAction:(UIBarButtonItem *) barItem {
    [self.navigationController popViewControllerAnimated:YES];
}
@end




#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation UINavigationBar (Awesome)
static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
