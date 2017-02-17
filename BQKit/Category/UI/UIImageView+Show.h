//
//  UIImageView+Show.h
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Show)<UIGestureRecognizerDelegate>
/**
 可通过点击视图对视图进行展示和手势操作
 */
- (void)canShowImage;
@end
