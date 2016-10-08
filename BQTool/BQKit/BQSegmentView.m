//
//  BQSegmentView.m
//  HJLPlatform
//
//  Created by MAC on 16/10/8.
//  Copyright © 2016年 HJL. All rights reserved.
//

#import "BQSegmentView.h"

@interface BQSegmentView ()<CAAnimationDelegate>

/**  标题栏 */
@property (nonatomic, strong) NSArray<NSString *> * titleArray;
@property (nonatomic, strong) UIColor * color;
/**  底部动画视图 */
@property (nonatomic, strong) CAShapeLayer *animationLayer;
/**  之前选中的按钮 */
@property (nonatomic, strong) UIButton * preBtn;
/**  锁住第几个按钮,按钮需小于标题个数 */
@property (nonatomic, assign) NSInteger lockIndex;
/**  未锁的回调方法 */
@property (nonatomic, copy) void (^callBack)(NSInteger index);
/**  被锁的回调方法 */
@property (nonatomic, copy) void(^lockCallBack)();
@end

@implementation BQSegmentView

-  (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color titleArray:(NSArray<NSString *> *)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.lockIndex = -1;
        self.color = color;
        self.titleArray = titleArray;
        [self initData];
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        color:(UIColor *)color
{
    self = [[BQSegmentView alloc] initWithFrame:frame color:color titleArray:nil];
    return self;
}

- (void)initData {
    if (self.titleArray == nil) {
        self.titleArray = @[@"店铺设置",@"认证信息",@"营业状态",@"申请续签"];
    }
    if (self.color == nil) {
        self.color = [UIColor redColor];
    }
}

- (void)initUI {
    
    
    CGFloat width = self.bounds.size.width / self.titleArray.count;;
    CGFloat height = self.bounds.size.height;
    
    for (int i = 0; i < self.titleArray.count; ++i) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        btn.frame = CGRectMake(i * width, 0, width, height);
        btn.tag = 100 + i;
        NSString * title = self.titleArray[i];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateSelected];
        [btn setTitleColor:self.color forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0) {
            self.preBtn = btn;
        }
    }
    
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.frame = CGRectMake(0, height - 2, width, 2);
    lineLayer.backgroundColor = self.color.CGColor;
    [self.layer addSublayer:lineLayer];
    self.animationLayer = lineLayer;
    
    if (self.lockIndex < 0 || self.lockIndex >= self.titleArray.count) {
        self.preBtn.selected = !self.preBtn.selected;
    }else {
        
    }
}
#pragma mark - Btn Action
- (void)btnAction:(UIButton *) btn {
    
    if (self.lockIndex < 0 || self.lockIndex >= self.titleArray.count) {
        [self beaginAimationWithBtn:btn];
    }else if(self.lockCallBack != nil) {
        self.lockCallBack();
    }
}

- (void)beaginAimationWithBtn:(UIButton *) btn {
    
    if (btn == self.preBtn) {
        return;
    }
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.toValue = @(btn.center.x);
    animation.duration = 0.25f;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.animationLayer addAnimation:animation forKey:@""];
    
    btn.selected = !btn.selected;
    self.preBtn.selected = !self.preBtn.selected;
    self.preBtn = btn;
    NSInteger index = [self.titleArray indexOfObject:btn.currentTitle];
    if (self.callBack != nil) {
        self.callBack(index);
    }
}

- (void)clickBtnUsingBlock:(void (^)(NSInteger))block {
    self.callBack = block;
}

- (void)lockIndex:(NSInteger)index ClickedUsingBlock:(void (^)())block {
    self.lockIndex = index;
    self.lockCallBack = block;
}

- (void)setLockIndex:(NSInteger)lockIndex {
    _lockIndex = lockIndex;
    if (_lockIndex >= 0 && _lockIndex < self.titleArray.count) {
        UIButton * btn = [self viewWithTag:100 + lockIndex];
        [self beaginAimationWithBtn:btn];
    }
}
@end
