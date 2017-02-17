//
//  BQPopView.m
//  Test
//
//  Created by MAC on 16/11/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BQMsgView.h"

@interface BQMsgView ()
/** 标题内容 */
@property (nonatomic, copy) NSString * title;
/** 内容 */
@property (nonatomic, copy) NSString * content;
/** 动画View */
@property (nonatomic, strong) UIView * anmationView;
@end

@implementation BQMsgView
#pragma mark - Class Method
+ (void)showInfo:(NSString *)info {
    [self showTitle:nil info:info];
}
+ (void)showInfo:(NSString *)info completeBlock:(void (^)())callblock {
    [self showTitle:nil info:info completeBlock:callblock];
}
+ (void)showTitle:(NSString *)title info:(NSString *)info {
    [self showTitle:title info:info completeBlock:nil];
}
+ (void)showTitle:(NSString *)title info:(NSString *)info completeBlock:(void (^)())callblock {
    BQMsgView * popView = [[BQMsgView alloc] initWithFrame:[UIScreen mainScreen].bounds title:title info:info] ;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    popView.anmationView.transform = CGAffineTransformScale(popView.anmationView.transform, 1.1, 1.1);
    [UIView animateWithDuration:0.15f animations:^{
        popView.anmationView.transform = CGAffineTransformIdentity;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            popView.alpha = 0;
        } completion:^(BOOL finished) {
            [popView removeFromSuperview];
            if (callblock != nil) {
                callblock();
            }
        }];
    });
}

#pragma mark - create Class

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title info:(NSString *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        if (title.length > 0) {
            self.title = title;
        }
        self.content = info;
        [self initUI];
    }
    return self;
}

#pragma mark - instancetype Method

- (void)initUI {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat font = width / 375 * 15;
    CGRect contentRect = [self.content boundingRectWithSize:CGSizeMake(width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    CGRect titleRect = [self.title boundingRectWithSize:CGSizeMake(width - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font + 2]} context:nil];
    NSLog(@"\ntitle %@\n content %@",NSStringFromCGRect(contentRect),NSStringFromCGRect(titleRect));
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    
    
    UIView *backView = [[UIView alloc] init];
    CGFloat backViewHeight = self.title != nil ? titleRect.size.height + contentRect.size.height + 40 : contentRect.size.height + 30;
    backView.frame = CGRectMake(0, 0, width - 100, backViewHeight);
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    backView.layer.cornerRadius = 8.f;
    backView.clipsToBounds = YES;
    backView.center = CGPointMake(width * 0.5, height * 0.5);
    [self addSubview:backView];
    self.anmationView = backView;
    
    if (self.title) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, width - 100, titleRect.size.height)];
        titleLabel.font = [UIFont boldSystemFontOfSize:font + 2];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        [backView addSubview:titleLabel];
    }
    UILabel * contentlabel = [[UILabel alloc] initWithFrame:contentRect];
    contentlabel.font = [UIFont systemFontOfSize:font];
    contentlabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    contentlabel.text = self.content;
    contentlabel.numberOfLines = 0;
    CGFloat centerY = self.title != nil ? titleRect.size.height + contentRect.size.height * 0.5 + 25 : contentRect.size.height * 0.5 + 15;
    contentlabel.center = CGPointMake(backView.bounds.size.width * 0.5, centerY);
    [backView addSubview:contentlabel];
      
}
@end
