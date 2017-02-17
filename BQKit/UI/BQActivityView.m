//
//  BQActivityView.m
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "BQActivityView.h"

static BQActivityView *activiyView;

@interface BQActivityView ()
@property (nonatomic, strong) CAReplicatorLayer *reaplicator;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CALayer *showlayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger showTimes;
@end

@implementation BQActivityView

+ (void)showActiviTy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (activiyView == nil) {
            CGRect rect = [UIScreen mainScreen].bounds;
            activiyView = [[self alloc] initWithFrame:rect];
            activiyView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        }
    });
    activiyView.showTimes += 1;
    
    activiyView.alpha = 1;
}

+ (void)hideActiviTy {
    if (activiyView.showTimes > 0) {
        activiyView.showTimes -= 1;
    }
    if (activiyView.showTimes == 0){
        [UIView animateWithDuration:0.25f animations:^{
            activiyView.alpha = 0;
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showTimes = 0;
        [self.contentView addSubview:self.label];
        [self.contentView.layer addSublayer:self.reaplicator];
        [self addSubview:self.contentView];
        [self startAnimation];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.alpha = 0;
    }
    return self;
}
- (void)startAnimation {
    
    //对layer进行动画设置
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    //设置动画所关联的路径属性
    animaiton.keyPath = @"transform.scale";
    //设置动画起始和终结的动画值
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    //设置动画时间
    animaiton.duration = 1.0f;
    //填充模型
    animaiton.fillMode = kCAFillModeForwards;
    //不移除动画
    animaiton.removedOnCompletion = NO;
    //设置动画次数
    animaiton.repeatCount = INT_MAX;
    //添加动画
    [self.showlayer addAnimation:animaiton forKey:@"anmation"];
}
- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        contentView.layer.cornerRadius = 10.0f;
        contentView.layer.borderColor = [UIColor colorWithWhite:0.926 alpha:1.000].CGColor;
        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        contentView.layer.shadowOpacity = 0.1;
        contentView.layer.shadowOffset = CGSizeMake(1, 1);
        contentView.center = self.center;
        contentView.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;
    }
    return _contentView;
}
- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reaplicator.frame), CGRectGetWidth(self.contentView.frame), 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        _label = label;
    }
    return _label;
}
- (CAReplicatorLayer *)reaplicator{
    if (_reaplicator == nil) {
        int numofInstance = 10;
        CGFloat duration = 1.0f;
        //创建repelicator对象
        CAReplicatorLayer *repelicator = [CAReplicatorLayer layer];
        //设置其位置
        repelicator.bounds = CGRectMake(0, 0, 50, 50);
        repelicator.position = CGPointMake(self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.5);
        //需要生成多少个相同实例
        repelicator.instanceCount = numofInstance;
        //代表实例生成的延时时间;
        repelicator.instanceDelay = duration / numofInstance;
        //设置每个实例的变换样式
        repelicator.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
        //创建repelicator对象的子图层，repelicator会利用此子图层进行高效复制。并绘制到自身图层上
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 8, 8);
        //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此锚点附近。
        CGPoint point = [repelicator convertPoint:repelicator.position fromLayer:self.layer];
        layer.position = CGPointMake(point.x, point.y - 20);
#warning 修改等待提示颜色
        layer.backgroundColor = [UIColor cyanColor].CGColor;
        
        layer.cornerRadius = 5;
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showlayer = layer;
        //将子图层添加到repelicator上
        [repelicator addSublayer:layer];
        _reaplicator = repelicator;
    }
    return _reaplicator;
}
@end
