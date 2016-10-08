//
//  BQSegmentView.h
//  HJLPlatform
//
//  Created by MAC on 16/10/8.
//  Copyright © 2016年 HJL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQSegmentView : UIView



- (instancetype)initWithFrame:(CGRect)frame
                        color:(UIColor *)color;

- (instancetype)initWithFrame:(CGRect)frame
                        color:(UIColor *)color
                   titleArray:(NSArray<NSString *> *)titleArray;

/**
 点击回调block,当lockIndex<0时有效

 @param block 回调方法
 */
- (void)clickBtnUsingBlock:(void(^)(NSInteger index))block;

/**
 被锁时的点击回调block,锁住后无动画

 @param index 锁住的按钮
 @param block 锁住后按钮点击回调方法
 */
- (void)lockIndex:(NSInteger)index
ClickedUsingBlock:(void(^)())block;
@end
