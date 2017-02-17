//
//  UIButton+EdgeInsets.h
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BtnEdgeType) {
    BtnEdgeType_center,
    BtnEdgeType_left,
    BtnEdgeType_right,
    BtnEdgeType_imageTopLabBottom,
};

@interface UIButton (EdgeInsets)
- (void)adjustLabAndImageLocation:(BtnEdgeType)type;
@end
