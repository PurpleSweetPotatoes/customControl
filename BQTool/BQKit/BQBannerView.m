//
//  BQBannerView.m
//  Test
//
//  Created by MAC on 16/12/19.
//  Copyright © 2016年 MrBai. All rights reserved.
//

#import "BQBannerView.h"
#import "BQTools.h"

#ifdef UIImageView
#import <UIImageView+WebCache.h>
#endif

static const NSTimeInterval  times = 2.0;

@interface BQBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSArray<UIImageView *> * imageViewArr;
@property (nonatomic, assign) NSInteger  currentIndex;
@property (nonatomic, strong) CADisplayLink * timer;
@property (nonatomic, copy) void(^clickBlock)(NSInteger index);
@end

@implementation BQBannerView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<NSString *> *)dataSource
{
    self = [self initWithFrame:frame];
    self.dataSource = dataSource;
    [self reloadSource];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
#ifndef UIImageView
        [BQTools showMessageWithTitle:@"提示" content:@"需要配置SDWebImage库支持!"];
#endif
    }
    return self;
}
- (void)initData {
    NSMutableArray * arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; ++i) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        [arr addObject:imageView];
    }
    self.imageViewArr = arr;
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeValueChange:)];
    self.timer.frameInterval = 60 * times;
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (UIImageView * imageView in self.imageViewArr) {
        [self.scrollView addSubview:imageView];
    }
    [self addSubview:self.scrollView];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0 , 60, 20)];
    self.pageControl.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - self.pageControl.bounds.size.height * 0.8);
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview:self.pageControl];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
    [self addGestureRecognizer:tap];
}
- (void)timeValueChange:(NSTimer *)timer {
    NSInteger index = self.currentIndex + 1;
    self.currentIndex = index % self.dataSource.count;
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
}
- (void)leftScroll {
    
}
#pragma mark - timer 
- (void)beginTime {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(times * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer.paused = NO;
    });
}
#pragma mark - GestureEvent
- (void)tapGestureEvent {
    if (self.clickBlock) {
        self.clickBlock(self.currentIndex);
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.timer.paused = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self beginTime];
    if (scrollView.contentOffset.x != self.bounds.size.width) {
        NSInteger index = scrollView.contentOffset.x > self.bounds.size.width ? 1 : -1;
        self.currentIndex = (self.currentIndex + index) % self.dataSource.count;
        [self imageChage];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self imageChage];
}
- (void)imageChage {
#ifdef UIImageView
    for (NSInteger i = -1; i < 2; ++ i) {
        NSInteger index = (self.currentIndex + i) % self.dataSource.count;
        [self.imageViewArr[i + 1] sd_setImageWithURL:[NSURL URLWithString:self.dataSource[index]]];
    }
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
#endif
}
- (void)bannerViewClickEvent:(void (^)(NSInteger))clickBlock {
    self.clickBlock = clickBlock;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)reloadSource {
    self.timer.paused = YES;
    self.pageControl.numberOfPages = self.dataSource.count;
    NSAssert(self.dataSource.count, @"The banner dataSource number cannot is zero");
    self.currentIndex = 0;
    [self imageChage];
    if (self.dataSource.count >= 2) {
        [self beginTime];
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        self.pageControl.hidden = NO;
    }else {
        self.scrollView.contentSize = self.bounds.size;
        self.pageControl.hidden = YES;
    }
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.pageControl.currentPage = currentIndex;
}
@end
